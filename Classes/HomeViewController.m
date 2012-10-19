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

@interface HomeViewController () {
    GameMode _gameMode;
}

@end

@implementation HomeViewController
@synthesize segmentedControl = _segmentedControl;

- (void)registerHandleMessage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:kSoundPlaySuccessMessage object:nil];
}

- (void)handleMessage:(NSNotification *)note {
    NSString * nib = [[NSString alloc] initWithFormat:@"QuestionMode%dGameViewController",_gameMode];
    QuestionModeGameViewController * viewController = [[QuestionModeGameViewController alloc] initWithNibName:nib bundle:nil];
    viewController.albumType = AlbumTypeFamily;
    viewController.gameMode = _gameMode;
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
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (IBAction)startGame:(UIButton *)sender {
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
