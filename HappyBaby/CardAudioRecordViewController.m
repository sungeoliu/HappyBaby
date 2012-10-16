//
//  CradAudioRecordViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-15.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "CardAudioRecordViewController.h"
#import "SoundManager.h"

@interface CardAudioRecordViewController () {
    SoundManager * _soundManager;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// FIMX 获取URL地址
- (IBAction)playSound:(UIButton *)sender {
    if (nil != _card) {
        // TODO 根据URL播放声音
        //_soundManager playSound:<#(NSURL *)#>
    }
}

// FIMX 获取URL地址
- (IBAction)recordSound:(UIButton *)sender {
    //获取URL地址
    //_soundManager recordSound:<#(NSURL *)#>;
}

- (IBAction)stopRecordSound:(UIButton *)sender {
    [_soundManager stopRecordSound];
}

// FIMX 保存数据库
- (IBAction)save:(UIButton *)sender {
    
}

- (IBAction)close:(UIButton *)sender {
    [self.view removeFromSuperview];
}

@end
