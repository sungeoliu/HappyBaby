//
//  BaseGameViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardManager.h"
#import "Card.h"
#import "GameEngine.h"
#import "SoundManager.h"

typedef enum {
    AnswerStateReady,
    AnswerStateWait,
    AnswerStateTimeout,
    AnswerStateRight,
    AnswerStateWrong
}AnswerState;

#define kCardSize  6
#define kImageViewTagOrigin 6
#define kLabelTagOrigin 12

@interface BaseGameViewController : UIViewController <GameEngineDelegate>

@property(weak, nonatomic) IBOutlet UILabel * labelInfo;

@property (strong, nonatomic)  NSArray * cards;
@property (nonatomic) AlbumType albumType;
@property (nonatomic) AnswerState answerState;
@property (weak, nonatomic) SoundManager * soundManager;
@property (weak, nonatomic) Question * question;
@property (strong, nonatomic) GameEngine * gameEngine;
@property(nonatomic) GameMode gameMode;

- (void)initCardsWithAlbum:(AlbumType)albumType;
- (void)shakeView:(UIButton *)view;
- (void)playFirework;
- (void)stopFirework;
- (Card *)cardWithId:(NSNumber *)cardId;
- (void)initViewWithOptions:(NSArray *)options;

- (void)handleGotQuestion:(Question *)question;
- (void)handleRightAnswerForObject:(NSNumber *)objectId;
- (void)handleWrongAnswerForObject:(NSNumber *)objectId;
- (void)handleAnswerTimeout:(NSNumber *)objectId;
- (void)handleQuestionTimerCountdown:(NSNumber *) secondsLeft;

- (IBAction)back:(id)sender;

@end
