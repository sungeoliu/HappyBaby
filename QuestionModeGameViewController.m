//
//  QuestionModeGameViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "QuestionModeGameViewController.h"
#import "SoundManager.h"

@interface QuestionModeGameViewController () {
    GameEngine * _gameEngine;
    SoundManager * _soundManager;
    NSInteger  _curSelectCardIndex;
    NSNumber * _curSelectCardId;
    NSArray * _options;
}

@end

@implementation QuestionModeGameViewController
@synthesize labelCountdown = _labelCountdown;

#pragma 私有函数
- (void)showAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

}
// 检查卡片图片、录音是否进行设置
- (BOOL)checkCards {
    if (nil != self.cards) {
        NSInteger count = self.cards.count;
        Card * card;
        for (NSInteger index = 0; index < count; index++) {
            card = [self.cards objectAtIndex:index];
            if (nil == card.image || nil == card.pronunciation) {
                [self showAlert];
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)initViewWithOptions:(NSArray *)options{
    if (nil != options) {
        _options = options;
        UIImage * image;
        NSURL * url;
        NSData * data;
        NSNumber * cardId;
        Card * card;
        UIButton * button;
        UILabel * label;
        
        NSInteger count = options.count;
        for (NSInteger index = 0; index < count; index++) {
            cardId = [options objectAtIndex:index];
            card = [self cardWithId:cardId];
            
            button = (UIButton *)[self.view viewWithTag:index + 1];
            url = [[NSURL alloc] initWithString:card.image];
            data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
            label = (UILabel *)[self.view viewWithTag:-1 - index];
            label.text = card.name;
        }
    }
}

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
            [_gameEngine newQuestion];
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
        _gameEngine = [[GameEngine alloc] init];
        _gameEngine.delegate = self;
        _soundManager = [SoundManager defaultManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gameEngine.answerQuestionTimerInterval = 10;
    _gameEngine.gameMode = self.gameMode;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self checkCards]) {
        self.answerState = AnswerStateReady;
        [_gameEngine startGameWithAlbum:self.albumType];
        [_gameEngine newQuestion];

        [_soundManager playBackgroundSound];
    }
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

- (IBAction)back:(id)sender {
    _gameEngine.delegate = nil;
    [_gameEngine stopGame];
    [_soundManager stopBackgroundSound];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkAnswer:(UIButton *)sender {
    if (nil != _options) {
        _curSelectCardIndex = sender.tag;
        _curSelectCardId = [_options objectAtIndex:sender.tag - 1 ];
        [_gameEngine checkAnswer:_curSelectCardId];
    }
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma GameEngineDelegate
- (void)gotQuestion:(Question *)question {
    if (nil != question) {
        [self.labelInfo setText:question.prompt];
    }
    [self initViewWithOptions:question.options];
    self.answerState = AnswerStateWait;
    [_soundManager playSound:question.voice];
}

- (void)rightAnswerForObject:(NSNumber *)objectId {
    [self playFirework];
    self.answerState = AnswerStateRight;
    [_soundManager playSystemSound:SystemSoundRight];
}

- (void)wrongAnswerForObject:(NSNumber *)objectId {
    self.answerState = AnswerStateWrong;
    [_soundManager playSystemSound:SystemSoundWrong];
    [self shakeWithButtonTag:_curSelectCardIndex];
}

- (void)answerTimeout:(NSNumber *)objectId {
    self.answerState = AnswerStateTimeout;
    [_soundManager playSystemSound:SystemSoundWrong];
    [self shakeWithButtonTag:[self buttonTagWithCardId:objectId]];
}

- (void)questionTimerCountdown:(NSNumber *) secondsLeft {
    _labelCountdown.text = [secondsLeft stringValue];
}

#pragma AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self back:nil];
    }
}

@end
