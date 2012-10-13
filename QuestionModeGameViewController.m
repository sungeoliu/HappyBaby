//
//  QuestionModeGameViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "QuestionModeGameViewController.h"
#import "SoundManager.h"

#define kCardSize  6

@interface QuestionModeGameViewController () {
    GameEngine * _gameEngine;
    SoundManager * _soundManager;
}

@end

@implementation QuestionModeGameViewController

#pragma 私有函数
- (void)initView {
    if (nil != self.cards && self.cards.count == kCardSize) {
        Card * card = [self.cards objectAtIndex:0];
        _button1.tag = [card.id integerValue];
        _label1.text = card.name;
        card = [self.cards objectAtIndex:1];
        _button2.tag = [card.id integerValue];
        _label2.text = card.name;
        card = [self.cards objectAtIndex:2];
        _button3.tag = [card.id integerValue];
        _label3.text = card.name;
        card = [self.cards objectAtIndex:3];
        _button4.tag = [card.id integerValue];
        _label4.text = card.name;
        card = [self.cards objectAtIndex:4];
        _button5.tag = [card.id integerValue];
        _label5.text = card.name;
        card = [self.cards objectAtIndex:5];
        _button6.tag = [card.id integerValue];
        _label6.text = card.name;
    }
}

- (void)shakeWithButtonTag:(NSNumber *)tagId {
    NSInteger intTagId = [tagId integerValue];
    UIButton * button = (UIButton *)[self.view viewWithTag:intTagId];
    [self shakeView:button];
}

- (void)registerHandleMessage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:kSoundPlaySuccessMessage object:nil];
}

- (void)handleMessage:(NSNotification *)note {
    switch (self.answerState) {
        case AnswerStateRight:
        case AnswerStateTimeout:
            [_gameEngine newQuestion];
            break;
            
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
    // Do any additional setup after loading the view from its nib.
    //[self initView];
    [self registerHandleMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[_gameEngine startGameWithAlbum:self.albumType];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_soundManager playBackgroundSound];
    //[_gameEngine newQuestion];
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
    //[_gameEngine checkAnswer:[NSNumber numberWithInteger:sender.tag]];
    [self shakeWithButtonTag:[NSNumber numberWithInteger:sender.tag]];
}

#pragma GameEngineDelegate
- (void)gotQuestion:(NSString *)question withVoice:(NSURL *)voice {
    self.labelInfo.text = question;
    self.answerState = AnswerStateWait;
    [_soundManager playSound:voice];
}

- (void)rightAnswerForObject:(NSNumber *)objectId {
    self.answerState = AnswerStateRight;
    // TODO 播放奖励的声音
}

- (void)wrongAnswerForObject:(NSNumber *)objectId {
    [self shakeWithButtonTag:objectId];
    self.answerState = AnswerStateWrong;
    [_gameEngine newQuestion];
}

- (void)anwserTimeout:(NSNumber *)objectId {
    self.answerState = AnswerStateTimeout;
    // TODO 播放提示的声音
}

@end
