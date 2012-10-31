//
//  HomeViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "HomeViewController.h"
#import "QuestionModeGameViewController.h"
#import "GameEngine.h"
#import "SoundManager.h"
#import "Feature.h"
#import "StudyModeGameViewController.h"
#import "CardManagerViewController.h"

@interface HomeViewController () {
    GameMode _gameMode;
}

@end

@implementation HomeViewController
@synthesize buttonStudy = _buttonStudy;
@synthesize buttonGame = _buttonGame;
@synthesize labelBottom = _labelBottom;
@synthesize labelTop = _labelTop;
@synthesize buttonSet = _buttonSet;

#pragma 私有函数
- (void)setBackgroundColorWithLabel:(UILabel *)label {
    [label setBackgroundColor:[[Feature defaultFeature] pinkColor]];
}

- (void)setBackgroundColorWithButton:(UIButton *)button {
    [button setBackgroundColor:[[Feature defaultFeature] pinkColor]];
}

- (void)showShadowAndRadius:(UIButton *)button {
    button.layer.masksToBounds = NO;
    button.layer.shouldRasterize = YES;
    button.layer.cornerRadius = 8.0f;
    button.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    button.layer.shadowOpacity = 0.7;
    button.layer.shadowColor =  [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor =  [UIColor whiteColor].CGColor;
}

- (void)hideShadow:(UIButton *)button {
    button.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    button.layer.shadowOpacity = 0.0;
}

- (void)registerHandleMessage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:kSoundPlaySuccessMessage object:nil];
}

- (void)handleMessage:(NSNotification *)note {
    [self showGameViewController];
}

- (void)showGameViewController {
    NSString * nib = [[NSString alloc] initWithFormat:@"QuestionMode%dGameViewController",_gameMode];
    QuestionModeGameViewController * viewController = [[QuestionModeGameViewController alloc] initWithNibName:nib bundle:nil];
    viewController.albumType = AlbumTypeFamily;
    viewController.gameMode = _gameMode;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

// 检查卡片图片、录音是否进行设置
- (BOOL)checkCards {
    NSArray * cards = [[CardManager defaultManager] allCardsInAlbum:AlbumTypeFamily];
    if (nil != cards) {
        NSInteger count = cards.count;
        Card * card;
        for (NSInteger index = 0; index < count; index++) {
            card = [cards objectAtIndex:index];
            if (nil == card.image || nil == card.pronunciation) {
                [self showAlert];
                return NO;
            }
        }
    }else {
        return NO;
    }
    
    return YES;
}

- (void)showAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置所有卡片照片并录制声音" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}

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
    [self showShadowAndRadius:_buttonStudy];
    [self showShadowAndRadius:_buttonGame];
    [self showShadowAndRadius:_buttonSet];
    [self setBackgroundColorWithLabel:_labelTop];
    [self setBackgroundColorWithLabel:_labelBottom];
    [self setBackgroundColorWithButton:_buttonStudy];
    [self setBackgroundColorWithButton:_buttonGame];
    [self setBackgroundColorWithButton:_buttonSet];
    [self.navigationController setNavigationBarHidden:YES];

    if (NO == [self checkCards]) {
        [self cardManager:nil];
    }
    _gameMode = GameModeOneOption;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerHandleMessage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)touchDown:(UIButton *)sender {
    [self hideShadow:sender];
}

- (IBAction)touchCancel:(UIButton *)sender {
    [self showShadowAndRadius:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

/*- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}*/

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (IBAction)startGame:(UIButton *)sender {
    if (YES == [self checkCards]) {
        _gameMode = sender.tag + GameModeOneOption;
        [self showShadowAndRadius:sender];
        [[SoundManager defaultManager] playSystemSound:SystemSoundReady];
    }
}

- (IBAction)setCard:(UIButton *)sender {
    if (YES == [self checkCards]) {
        _gameMode = sender.tag + GameModeOneOption;
        [self showShadowAndRadius:sender];
        NSString * nib = [[NSString alloc] initWithFormat:@"QuestionMode%dGameViewController",_gameMode];
        StudyModeGameViewController * viewController = [[StudyModeGameViewController alloc] initWithNibName:nib bundle:nil];
        viewController.albumType = AlbumTypeFamily;
        viewController.gameMode = _gameMode;
    
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)cardManager:(UIButton *)sender {
    [self showShadowAndRadius:sender];
    CardManagerViewController * viewController = [[CardManagerViewController alloc] initWithNibName:@"CardManagerViewController" bundle:nil];
    viewController.albumType = AlbumTypeFamily;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
