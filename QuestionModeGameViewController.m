//
//  QuestionModeGameViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "QuestionModeGameViewController.h"

@interface QuestionModeGameViewController () {
    NSInteger  _curSelectCardIndex;
    NSNumber * _curSelectCardId;
    NSArray * _options;
}

@end

@implementation QuestionModeGameViewController
@synthesize labelCountdown = _labelCountdown;
@synthesize viewBackground = _viewBackground;

#pragma 私有函数
- (NSInteger)buttonTagWithCardId:(NSNumber *)cardId {
    if (nil != _options) {
        NSInteger count = _options.count;
        for (NSInteger index = 0; index < count; index++) {
            if (cardId == [_options objectAtIndex:index]) {
                return index + 1;
            }
        }
    }
    
    return 0;
}

- (void)shakeWithButtonTag:(NSInteger)tagId {
    UIButton * button = (UIButton *)[self.view viewWithTag:tagId];
    [self shakeView:button];
}

- (void)registerHandleMessage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:kSoundPlaySuccessMessage object:nil];
}

- (void)handleMessage:(NSNotification *)note {
    switch (self.answerState) {
        case AnswerStateRight:
        case AnswerStateTimeout:
            [self stopFirework];
            [self.gameEngine newQuestion];
            break;
        case AnswerStateReady:
        default:
            break;
    }
}

#pragma 事件函数
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.answerState = AnswerStateReady;
    [self.gameEngine startGameWithAlbum:self.albumType];
    [self.gameEngine newQuestion];
    [self.soundManager playBackgroundSound];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerHandleMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkAnswer:(UIButton *)sender {
    if (nil != _options) {
        _curSelectCardIndex = sender.tag;
        _curSelectCardId = [_options objectAtIndex:sender.tag - 1 ];
        [self.gameEngine checkAnswer:_curSelectCardId];
    }
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma GameEngineDelegate
- (void)handleGotQuestion:(Question *)question {
    if (nil != question) {
        [self.labelInfo setText:question.prompt];
    }
    _options = question.options;
    if (nil != question.voice) {
        [self.soundManager playSound:question.voice];
    }
  
    [self initViewWithOptions:question.options];
    self.answerState = AnswerStateWait;
}

- (void)handleRightAnswerForObject:(NSNumber *)objectId {
    [self playFirework];
    self.answerState = AnswerStateRight;
    [self.soundManager playSystemSound:SystemSoundRight];
}

- (void)handleWrongAnswerForObject:(NSNumber *)objectId {
    self.answerState = AnswerStateWrong;
    [self.soundManager playSystemSound:SystemSoundWrong];
    [self shakeWithButtonTag:_curSelectCardIndex];
}

- (void)handleAnswerTimeout:(NSNumber *)objectId {
    self.answerState = AnswerStateTimeout;
    [self.soundManager playSystemSound:SystemSoundWrong];
    [self shakeWithButtonTag:[self buttonTagWithCardId:objectId]];
}

- (void)handleQuestionTimerCountdown:(NSNumber *) secondsLeft {
    _labelCountdown.text = [secondsLeft stringValue];
}
@end
