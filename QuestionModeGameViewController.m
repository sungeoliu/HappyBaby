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
}

@end

@implementation QuestionModeGameViewController

#pragma 私有函数
- (void)showAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请进行设置数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

}
// 检查卡片图片、录音是否进行设置
- (BOOL)checkCards {
    if (nil == self.cards) {
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

- (void)initView {
    if (nil != self.cards && self.cards.count == kCardSize) {
        UIImage * image;
        NSURL * url;
        NSData * data;
        
        Card * card = [self.cards objectAtIndex:0];
        _button1.tag = [card.id integerValue];
        url = [[NSURL alloc] initWithString:card.image];
        data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        [_button1 setBackgroundImage:image forState:UIControlStateNormal];
        _label1.text = card.name;
        
        card = [self.cards objectAtIndex:1];
        _button2.tag = [card.id integerValue];
        url = [[NSURL alloc] initWithString:card.image];
        data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        [_button2 setBackgroundImage:image forState:UIControlStateNormal];
        _label2.text = card.name;
        
        card = [self.cards objectAtIndex:2];
        _button3.tag = [card.id integerValue];
        url = [[NSURL alloc] initWithString:card.image];
        data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        [_button3 setBackgroundImage:image forState:UIControlStateNormal];
        _label3.text = card.name;
        
        card = [self.cards objectAtIndex:3];
        _button4.tag = [card.id integerValue];
        image = [[UIImage alloc] initWithContentsOfFile:card.image];
        [_button4 setBackgroundImage:image forState:UIControlStateNormal];
        _label4.text = card.name;
        
        card = [self.cards objectAtIndex:4];
        _button5.tag = [card.id integerValue];
        url = [[NSURL alloc] initWithString:card.image];
        data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        [_button5 setBackgroundImage:image forState:UIControlStateNormal];
        _label5.text = card.name;
        
        card = [self.cards objectAtIndex:5];
        _button6.tag = [card.id integerValue];
        url = [[NSURL alloc] initWithString:card.image];
        data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        [_button6 setBackgroundImage:image forState:UIControlStateNormal];
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
        case AnswerStateWrong:
            [_gameEngine newQuestion];
            break;
        case AnswerStateReady:
            [_gameEngine startGameWithAlbum:self.albumType];
            [_gameEngine newQuestion];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self checkCards]) {
        [self initView];
        self.answerState = AnswerStateReady;
        [_soundManager playSystemSound:SystemSoundReady];
        [_soundManager playBackgroundSound];
    }
    
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
    [_gameEngine checkAnswer:[NSNumber numberWithInteger:sender.tag]];
}

#pragma GameEngineDelegate
- (void)gotQuestion:(NSString *)question withVoice:(NSURL *)voice {
    if (nil != question) {
        [self.labelInfo setText:question];
    }
    
    self.answerState = AnswerStateWait;
    [_soundManager playSound:voice];
}

- (void)rightAnswerForObject:(NSNumber *)objectId {
    self.answerState = AnswerStateRight;
    [_soundManager playSystemSound:SystemSoundRight];
}

- (void)wrongAnswerForObject:(NSNumber *)objectId {
    [self shakeWithButtonTag:objectId];
    self.answerState = AnswerStateWrong;
    [_soundManager playSystemSound:SystemSoundWrong];
    [self shakeWithButtonTag:objectId];
}

- (void)anwserTimeout:(NSNumber *)objectId {
    self.answerState = AnswerStateTimeout;
    [_soundManager playSystemSound:SystemSoundWrong];
    [self shakeWithButtonTag:objectId];
}

#pragma AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self back:nil];
    }
}

@end
