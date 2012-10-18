//
//  GameEngine.h
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardManager.h"
#import "Question.h"

typedef enum{
    GameModeUndefined = 0,
    GameModeTwoOptions = 2,
    GameModeThreeOptions = 3,
    GameModeFourOptions = 4
}GameMode;

@protocol GameEngineDelegate <NSObject>

@optional
- (void)gotQuestion:(Question *)question;
- (void)wrongAnswerForObject:(NSNumber *)objectId;
- (void)rightAnswerForObject:(NSNumber *)objectId;
- (void)answerTimeout:(NSNumber *)objectId;
- (void)questionTimerCountdown:(NSNumber *) secondsLeft;

@end


@interface GameEngine : NSObject

@property (nonatomic) NSInteger answerQuestionTimerInterval;
@property (nonatomic) GameMode gameMode;
@property (nonatomic, strong) id<GameEngineDelegate> delegate;

- (void)startGameWithAlbum:(AlbumType)albumType;
- (void)stopGame;
- (void)newQuestion;
- (void)checkAnswer:(NSNumber *)objectId;

@end
