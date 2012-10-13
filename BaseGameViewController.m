//
//  BaseGameViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseGameViewController.h"

@interface BaseGameViewController () {

}

@end

@implementation BaseGameViewController

-(void)wobbleEnded:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context{
    if([finished boolValue]){
        UIView * item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
- (void)shakeView:(UIButton *)view {
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-4.0));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(4.0));
    
    view.transform = leftWobble;
    [UIView beginAnimations:@"wobble" context:(__bridge void *)(view)];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
    
    view.transform = rightWobble;
    
    [UIView commitAnimations];
}

- (void)initCardsWithAlbum:(AlbumType)albumType {
    _cards = [[CardManager defaultManager] allCardsInAlbum:albumType];
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
	// Do any additional setup after loading the view.
    [self initCardsWithAlbum:_albumType];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
