//
//  StudyModeGameViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-27.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "StudyModeGameViewController.h"
#import "CardAudioRecordViewController.h"
#import "Feature.h"

@interface StudyModeGameViewController () {
    BOOL _isEdit;
}

@end

@implementation StudyModeGameViewController
#pragma 事件函数

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.soundManager playBackgroundSound];
    [self.gameEngine startGameWithAlbum:self.albumType];
    [self.gameEngine newQuestion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAudio:(UIButton *)sender {
    [self.soundManager playSound:self.question.voice];
}

- (IBAction)newCard:(UIButton *)sender {
    [self.gameEngine newQuestion];
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)handleGotQuestion:(Question *)question {
    if (nil != question) {
        [self.labelInfo setText:question.prompt];
    }
    self.question = question;
    if (nil != question.voice) {
        [self.soundManager playSound:question.voice];
    }
    
    [self initViewWithOptions:question.options];
}

@end
