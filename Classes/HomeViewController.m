//
//  HomeViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "HomeViewController.h"
#import "QuestionModeGameViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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

- (IBAction)startGame:(UIButton *)sender {
    QuestionModeGameViewController * viewController = [[QuestionModeGameViewController alloc] initWithNibName:@"QuestionModeGameViewController" bundle:nil];
    viewController.albumType = AlbumTypeFamily;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
