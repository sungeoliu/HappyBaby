//
//  CradAudioRecordViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-15.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "CardAudioRecordViewController.h"
#import "SoundManager.h"
#import "CardManager.h"

@interface CardAudioRecordViewController () {
    SoundManager * _soundManager;
    CardManager * _cardManager;
    NSURL * _url;
}

@end

@implementation CardAudioRecordViewController

@synthesize card = _card;

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
    // Do any additional setup after loading the view from its nib.
    _soundManager = [SoundManager defaultManager];
    _cardManager = [CardManager defaultManager];
    if (nil != _card.pronunciation) {
        _url = [[NSURL alloc] initWithString:_card.pronunciation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// FIMX 获取URL地址
- (IBAction)playSound:(UIButton *)sender {
    if (nil != _card) {
        [_soundManager playSound:_url];
    }
}

// FIMX 获取URL地址
- (IBAction)recordSound:(UIButton *)sender {
    _url = [_cardManager newSoundUrl];
    [_soundManager recordSound:_url];
}

- (IBAction)stopRecordSound:(UIButton *)sender {
    [_soundManager stopRecordSound];
}

// FIMX 保存数据库
- (IBAction)save:(UIButton *)sender {
    [_cardManager modifyCard:_card withPronunciation:_url];
}

- (IBAction)close:(UIButton *)sender {
    [self.view removeFromSuperview];
}

@end
