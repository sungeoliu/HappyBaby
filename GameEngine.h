//
//  GameEngine.h
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardManager.h"

@protocol GameEngineDelegate <NSObject>

@optional
- (void)gotQuestion:(NSString *)question withVoice:(NSURL *)voice;
- (void)wrongAnswerForObject:(NSNumber *)objectId;
- (void)rightAnswerForObject:(NSNumber *)objectId;
- (void)answerTimeout:(NSNumber *)objectId;

@end


@interface GameEngine : NSObject

@property (nonatomic) NSInteger answerQuestionTimerInterval;
@property (nonatomic, strong) id<GameEngineDelegate> delegate;

- (void)startGameWithAlbum:(AlbumType)albumType;
- (void)stopGame;
- (void)newQuestion;
- (void)checkAnswer:(NSNumber *)objectId;

@end
