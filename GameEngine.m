//
//  GameEngine.m
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "GameEngine.h"
#import "CardManager.h"

@interface GameEngine(){
    NSArray * _cards;
    uint8_t * _questionSequenceTable;
    NSInteger _questionIndex;
    NSTimer * _questionTimer;
    NSInteger _countDownSeconds;
}

@end

/*
 游戏模式：
 1以每组图片总数为一组游戏，每组提问的卡片不会重复。
 2每组游戏中的卡片顺序均为随机生成。
 3一组提问结束后，开始下一次随机。
 */

@implementation GameEngine
@synthesize answerQuestionTimerInterval  = _answerQuestionTimerInterval;
@synthesize gameMode = _gameMode;
@synthesize delegate = _delegate;

- (u_int8_t *)newSequenceTableWithLength:(NSInteger)length{
    // generate chaos-maker table.
    u_int8_t * chaos = (u_int8_t *)malloc(length);
    if (0 != SecRandomCopyBytes(kSecRandomDefault, length, chaos)) {
        free(chaos);
        return nil;
    }
    
    // initialize sequence table;
    u_int8_t * sequence = (u_int8_t *)malloc(length);
    for (int i = 0; i < length; i++) {
        sequence[i] = i;
    }
    
    // using chaos-maker to disorder questionOrderTable.
    u_int8_t tmp;
    for (int i = 0 ; i < length; i ++) {
        chaos[i] = chaos[i] % length;

        // exchange values determined by chaos-maker table.
        tmp = sequence[i];
        sequence[i] = sequence[chaos[i]];
        sequence[chaos[i]] = tmp;
    }
    
    // NOTE !!!
    free(chaos);
    
    return sequence;
}

- (void)startGameWithAlbum:(AlbumType)albumType{
    _cards = [[CardManager defaultManager] allCardsInAlbum:albumType];
    _questionIndex = -1;
}

- (void)stopGame{
    free(_questionSequenceTable);
}

- (void)startTimerForCard:(Card *)card{
    [self stopTimer];

    _countDownSeconds = self.answerQuestionTimerInterval == 0 ? 5 : self.answerQuestionTimerInterval;
    _questionTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timeout:) userInfo:card.id repeats:YES];
}

- (void)stopTimer{
    if (_questionTimer != nil) {
        [_questionTimer invalidate];
    }
    
    _questionTimer = nil;
}

- (void)timeout:(NSTimer *)timer{
    _countDownSeconds --;
    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(questionTimerCountdown:)]) {
            [self.delegate performSelector:@selector(questionTimerCountdown:)
                                withObject:[NSNumber numberWithInteger:_countDownSeconds]];
        }
    }
    
    if (_countDownSeconds == 0) {
        if (self.delegate != nil) {
            if ([self.delegate respondsToSelector:@selector(answerTimeout:)]) {
                [self.delegate performSelector:@selector(answerTimeout:) withObject:timer.userInfo];
            }
        }
        
        [self stopTimer];
    }
    
    NSLog(@"question timeout");
}

- (Card *)currentQuestionCard{
    if (_questionIndex >= 0) {
        u_int8_t questionIndex = _questionSequenceTable[_questionIndex];
        return [_cards objectAtIndex:questionIndex];;
    }else{
        return nil;
    }
}

- (NSArray *)optionsForCurrentQuestion{
    if (self.gameMode == GameModeUndefined) {
        self.gameMode = GameModeTwoOptions;
    }
    
    // 从所有卡片中选择其中的N张，所以要根据卡片总数产生随机数组。
    u_int8_t * optionSequence = [self newSequenceTableWithLength:_cards.count];
    
    // 根据游戏模式，生成对应个数的选项。
    NSMutableArray * optionsArray = [NSMutableArray arrayWithCapacity:self.gameMode];
    for (int i = 0; i < self.gameMode; i ++) {
        [optionsArray addObject:@"empty"];
    }
    
    // 先随机确定答案卡片的位置。
    Card * answerCard = [self currentQuestionCard];
    int answerIndex = optionSequence[_cards.count - 1] % self.gameMode;
    NSLog(@"anser index %d id %d", answerIndex, [answerCard.id integerValue]);
    [optionsArray replaceObjectAtIndex:answerIndex withObject:answerCard.id];
//    [optionsArray insertObject:answerCard.id atIndex:answerIndex];
    
    // 再依次增加两张非答案的卡片。
    int optionIndex = 0;
    int optionCount = 1;
    for (int i = 0; i < _cards.count && optionCount < self.gameMode; i++) {
        int index = optionSequence[i];
        Card * optionCard = [_cards objectAtIndex:index];
        if ([optionCard.id isEqualToNumber:answerCard.id]) {
            // 跳过答案卡片，只会跳一次。
            continue;
        }
        
        // 跳过已经被答案卡片占用的位置。
        if (optionIndex == answerIndex) {
            optionIndex++;
        }
        
//        NSLog(@"card id %d", [optionCard.id integerValue]);
        [optionsArray replaceObjectAtIndex:optionIndex++ withObject:optionCard.id];
        optionCount ++;
    }
    
    free(optionSequence);
    
    for (int i = 0; i < self.gameMode; i++) {
        NSLog(@"Option %d: %d", i, [[optionsArray objectAtIndex:i] integerValue]);
    }
    
    return optionsArray;
}

- (void)nextQuestion{
    if (_questionIndex == -1 ||
        _questionIndex + 1 == _cards.count) {
        if (_questionSequenceTable != NULL) {
            free(_questionSequenceTable);
        }
        
        NSLog(@"new question sequence");
        _questionSequenceTable = [self newSequenceTableWithLength:_cards.count];
        _questionIndex = 0;
    }else{
        _questionIndex ++;
    }
}

- (void)newQuestion{
    [self nextQuestion];
    
    Card * card = [self currentQuestionCard];
    NSLog(@"new question for %@ with id %d", card.name, [card.id integerValue]);
    
    NSString * prompt = [NSString stringWithFormat:@"%@ 在哪里？", card.name];
    NSURL * soundURL = [NSURL URLWithString:card.pronunciation];
    NSArray * options = [self optionsForCurrentQuestion];
    Question * question = [[Question alloc] initWithPrompt:prompt withVoice:soundURL withOptions:options];
    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(gotQuestion:)]) {
            [self.delegate performSelector:@selector(gotQuestion:) withObject:question];
        }
    }
    
    [self startTimerForCard:card];
}

- (void)checkAnswer:(NSNumber *)objectId{
    BOOL result = NO;
    Card * card = [self currentQuestionCard];
    if ([card.id isEqualToNumber:objectId]) {
        result = YES;
    }

    if (self.delegate != nil) {
        if (result && [self.delegate respondsToSelector:@selector(rightAnswerForObject:)]) {
            [self stopTimer];
            [self.delegate performSelector:@selector(rightAnswerForObject:) withObject:card.id];
        }else if(!result && [self.delegate respondsToSelector:@selector(wrongAnswerForObject:)]){
            [self.delegate performSelector:@selector(wrongAnswerForObject:) withObject:card.id];
        }
    }
    
//    [self stopTimer];回答失败时继续计时，直到定时器超时。
}

@end
