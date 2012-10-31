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
    NSMutableArray * _cards;
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
@synthesize currentQuestion = _currentQuestion;

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

- (BOOL)startGameWithAlbum:(AlbumType)albumType{
    _questionIndex = -1;
    
    NSArray * allCards = [[CardManager defaultManager] allCardsInAlbum:albumType];
    if (allCards == nil || allCards.count == 0) {
        return NO;
    }
    

    _cards = [[NSMutableArray alloc] init];
    for (Card * card in allCards) {
//        if (card.image != nil && card.pronunciation != nil) {
            [_cards addObject:card];
//        }
    }
    
    if (_cards.count == 0) {
        return NO;
    }
    
    return YES;
}

- (void)stopGame{
    free(_questionSequenceTable);
    [self stopTimer];
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
    if (_questionIndex >= 0 && _questionIndex < _cards.count) {
        u_int8_t questionIndex = _questionSequenceTable[_questionIndex];
        return [_cards objectAtIndex:questionIndex];;
    }else{
        return nil;
    }
}

// 要求：
// 1,选项卡片要随机生成。2,答案在选项数组
- (NSArray *)optionsForCurrentQuestion{
    if (_questionIndex == -1) {
        return nil;
    }
    
    if (self.gameMode == GameModeUndefined) {
        self.gameMode = GameModeTwoOptions;
    }
    
    // 随机选择选项数目m张卡片。
    // 先根据卡片总数n产生同样长度的随机数组，取前m张，作为备选错误答案。
    u_int8_t * optionSequence = [self newSequenceTableWithLength:_cards.count];
    
    // 初始化选项数组。
    NSMutableArray * optionsArray = [NSMutableArray arrayWithCapacity:self.gameMode];
    for (int i = 0; i < self.gameMode; i ++) {
        [optionsArray addObject:@"empty"];
    }
    
    // 随机确定答案卡片的位置。
    Card * answerCard = [self currentQuestionCard];
    // 用刚才生成的随机数组的最后一项的值（随即数），对n取模，得到小于n的一个随机数，作为正确答案的位置。
    int answerIndex = optionSequence[_cards.count - 1] % self.gameMode;
    NSLog(@"anser index %d id %d", answerIndex, [answerCard.id integerValue]);
    [optionsArray replaceObjectAtIndex:answerIndex withObject:answerCard.id];
    
    // 再依次增加n-1张错误答案的卡片。
    int optionIndex = 0;
    int optionCount = 1;
    for (int i = 0; i < _cards.count && optionCount < self.gameMode; i++) {
        int index = optionSequence[i];
        Card * optionCard = [_cards objectAtIndex:index];
        if ([optionCard.id isEqualToNumber:answerCard.id]) {
            // 随机数组已经包含答案卡片，所以跳过答案卡片（只会跳一次）。
            continue;
        }
        
        // 跳过选项数组中已经占用答案卡片。
        if (optionIndex == answerIndex) {
            optionIndex++;
        }
        
        [optionsArray replaceObjectAtIndex:optionIndex++ withObject:optionCard.id];
        optionCount ++;
    }
    
    free(optionSequence);
    
    return optionsArray;
}

- (BOOL)nextQuestion{
    if (_cards == nil || _cards.count <= 0) {
        return NO;
    }
    
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
    
    return YES;
}

- (BOOL)newQuestion{
    [self nextQuestion];
    
    Card * card = [self currentQuestionCard];
    if (nil == card) {
        return NO;
    }
    
    NSLog(@"new question for %@ with id %d", card.name, [card.id integerValue]);
    
    NSArray * options = [self optionsForCurrentQuestion];
    self.currentQuestion = [[Question alloc] initWithAnswerCard:card withOptions:options];
    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(gotQuestion:)]) {
            [self.delegate performSelector:@selector(gotQuestion:) withObject:self.currentQuestion];
        }
    }
    
    [self startTimerForCard:card];
    
    return YES;
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
}

@end
