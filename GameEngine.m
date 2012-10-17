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
    uint8_t * _questionOrderTable;
    NSInteger _questionOrderIndex;
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
@synthesize delegate = _delegate;

- (void)initQuestionOrderTableWithLength:(NSInteger)length{
    if (_questionOrderTable != nil) {
        free(_questionOrderTable);
    }
    
    // fullfill table with ordered number.
    _questionOrderTable = (u_int8_t *)malloc(length);
    for (int i = 0; i < length; i++) {
        _questionOrderTable[i] = i;
    }
}

- (BOOL)generateQuestionOrderTableWithLength:(NSInteger)length{
    NSLog(@"generate question index table");
    
    // initialize order table;
    [self initQuestionOrderTableWithLength:length];

    // generate chaos-maker table.
    u_int8_t * bytes = (u_int8_t *)malloc(length);
    if (0 != SecRandomCopyBytes(kSecRandomDefault, length, bytes)) {
        free(bytes);
        return NO;
    }

    // using chaos-maker to disorder questionOrderTable.
    u_int8_t tmp;
    for (int i = 0 ; i < length; i ++) {
        bytes[i] = bytes[i] % length;

        // exchange values determined by chaos-maker table.
        tmp = _questionOrderTable[i];
        _questionOrderTable[i] = _questionOrderTable[bytes[i]];
        _questionOrderTable[bytes[i]] = tmp;
    }
    
    _questionOrderIndex = 0;
    
    // NOTE !!!
    free(bytes);
    
    return YES;
}

- (void)startGameWithAlbum:(AlbumType)albumType{
    _cards = [[CardManager defaultManager] allCardsInAlbum:albumType];
    _questionOrderIndex = -1;
}

- (void)stopGame{
    free(_questionOrderTable);
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
    
    if (_countDownSeconds == 0) {
        if (self.delegate != nil) {
            if ([self.delegate respondsToSelector:@selector(answerTimeout:)]) {
                [self.delegate performSelector:@selector(answerTimeout:) withObject:timer.userInfo];
            }
        }
        
        [self stopTimer];
    }else{
        if (self.delegate != nil) {
            if ([self.delegate respondsToSelector:@selector(questionTimerCountdown:)]) {
                [self.delegate performSelector:@selector(questionTimerCountdown:) withObject:[NSNumber numberWithInteger:_countDownSeconds]];
            }
        }
    }
    
    NSLog(@"question timeout");
}

- (Card *)currentQuestionCard{
    if (_questionOrderIndex >= 0) {
        u_int8_t questionIndex = _questionOrderTable[_questionOrderIndex];
        return [_cards objectAtIndex:questionIndex];;
    }else{
        return nil;
    }
}

- (void)newQuestion{
    if (_questionOrderIndex == -1 ||
        _questionOrderIndex + 1 == _cards.count) {
        [self generateQuestionOrderTableWithLength:_cards.count];
    }else{
        _questionOrderIndex ++;
    }
    
    Card * card = [self currentQuestionCard];
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(gotQuestion:withVoice:)]) {
            NSURL * soundURL = [NSURL URLWithString:card.pronunciation];
            [self.delegate performSelector:@selector(gotQuestion:withVoice:) withObject:card.name withObject:soundURL];
        }
    }
    
    NSLog(@"new question for %@ with id %d", card.name, [card.id integerValue]);
    
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
            [self.delegate performSelector:@selector(rightAnswerForObject:) withObject:card.id];
        }else if(!result && [self.delegate respondsToSelector:@selector(wrongAnswerForObject:)]){
            [self.delegate performSelector:@selector(wrongAnswerForObject:) withObject:card.id];
        }
    }
    
//    [self stopTimer];回答失败时继续计时，直到定时器超时。
}

@end
