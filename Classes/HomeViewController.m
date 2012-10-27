//
//  HomeViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "HomeViewController.h"
#import "QuestionModeGameViewController.h"
#import "CardManagerViewController.h"
#import "GameEngine.h"
#import "SoundManager.h"
#import "Feature.h"

@interface HomeViewController () {
    GameMode _gameMode;
}

@end

@implementation HomeViewController
@synthesize buttonStudy = _buttonStudy;
@synthesize buttonGame = _buttonGame;
@synthesize segmentedControl = _segmentedControl;
@synthesize labelBottom = _labelBottom;
@synthesize labelTop = _labelTop;

#pragma 私有函数
- (void)setBackgroundColorWithLabel:(UILabel *)label {
    [label setBackgroundColor:[[Feature defaultFeature] pinkColor]];
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
    NSString * nib = [[NSString alloc] initWithFormat:@"QuestionMode%dGameViewController",_gameMode];
    QuestionModeGameViewController * viewController = [[QuestionModeGameViewController alloc] initWithNibName:nib bundle:nil];
    viewController.albumType = AlbumTypeFamily;
    viewController.gameMode = _gameMode;
    
    /*[UIView beginAnimations:@"animationID" context:nil];//开始一个动画块，第一个参数为动画块标识
    [UIView setAnimationDuration:1.5f];//设置动画的持续时间
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置动画块中的动画属性变化的曲线，此方法必须在beginAnimations方法和commitAnimations，默认即为UIViewAnimationCurveEaseInOut效果。
    //详细请参见UIViewAnimationCurve
    [UIView setAnimationRepeatAutoreverses:NO];//设置是否自动反转当前的动画效果
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    //设置过渡的动画效果，此处第一个参数可使用上面5种动画效果。
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];//页面翻转
    [self.navigationController pushViewController:viewController animated:NO];
    [UIView commitAnimations];//提交动画*/
     [self.navigationController pushViewController:viewController animated:YES];
    
}

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
    [self setBackgroundColorWithLabel:_labelTop];
    [self setBackgroundColorWithLabel:_labelBottom];
    _gameMode = GameModeOneOption;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerHandleMessage];
    [self.navigationController setNavigationBarHidden:YES];
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
    _gameMode = sender.tag + GameModeOneOption;
    [self showShadowAndRadius:sender];
    [[SoundManager defaultManager] playSystemSound:SystemSoundReady];
}

- (IBAction)setCard:(UIButton *)sender {
    CardManagerViewController * viewController = [[CardManagerViewController alloc] initWithNibName:@"CardManagerViewController" bundle:nil];
    viewController.albumType = AlbumTypeFamily;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)gameModeChanged:(UISegmentedControl *)sender {
    _gameMode = sender.selectedSegmentIndex + GameModeOneOption;
}

@end
