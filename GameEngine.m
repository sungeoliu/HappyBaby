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
}

@end

/*
 游戏模式：
 1以每组图片总数为一组游戏，每组提问的卡片不会重复。
 2每组游戏中的卡片顺序均为随机生成。
 3一组提问结束后，开始下一次随机。
 */

@implementation GameEngine
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
    
    [self generateQuestionOrderTableWithLength:_cards.count];
    
}

- (void)stopGame{
    free(_questionOrderTable);
}

- (void)startTimerForCard:(Card *)card{
    [self stopTimer];
    _questionTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeout:) userInfo:card repeats:NO];
}

- (void)stopTimer{
    if (_questionTimer != nil) {
        [_questionTimer invalidate];
    }
    
    _questionTimer = nil;
}

- (void)timeout:(NSTimer *)timer{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(answerTimeout:)]) {
            [self.delegate performSelector:@selector(answerTimeout:) withObject:timer.userInfo];
        }
    }
    
    [self stopTimer];
}

- (Card *)currentQuestionCard{
    u_int8_t questionIndex = _questionOrderTable[_questionOrderIndex];
    return [_cards objectAtIndex:questionIndex];;
}

- (void)newQuestion{
    if ((_questionOrderIndex + 1) != _cards.count) {
        _questionOrderIndex ++;
    }else{
        [self generateQuestionOrderTableWithLength:_cards.count];
    }
    
    Card * card = [self currentQuestionCard];
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(gotQuestion:withVoice:)]) {
            // TODO pass voice to ...
            [self.delegate performSelector:@selector(gotQuestion:withVoice:) withObject:card withObject:nil];
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
            [self.delegate performSelector:@selector(rightAnswerForObject:) withObject:card];
        }else if(!result && [self.delegate respondsToSelector:@selector(wrongAnswerForObject:)]){
            [self.delegate performSelector:@selector(wrongAnswerForObject:) withObject:card];
        }
    }
    
    [self stopTimer];
}

@end
