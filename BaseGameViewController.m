//
//  BaseGameViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseGameViewController.h"
#import <QuartzCore/CoreAnimation.h>

@interface BaseGameViewController () {
    CAEmitterLayer * _fireworksEmitter;
}

@end

@implementation BaseGameViewController

- (void)showShadowWithButton:(UIButton *)button {
    button.layer.masksToBounds = NO;
    button.layer.shouldRasterize = YES;
    button.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    button.layer.shadowOpacity = 0.7;
    button.layer.shadowColor =  [UIColor blackColor].CGColor;
}

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

- (void)playFirework {
    if (nil != _fireworksEmitter) {
        [_fireworksEmitter removeFromSuperlayer];
    }
    
    _fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.view.layer.bounds;
    _fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    _fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);
    _fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
    _fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
    _fireworksEmitter.renderMode		= kCAEmitterLayerBackToFront;
    _fireworksEmitter.seed = (arc4random()%100)+1;
    
    // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate		= 1.0;
    rocket.emissionRange	= 0.25 * M_PI;  // some variation in angle
    rocket.velocity			= 380;
    rocket.velocityRange	= 100;
    rocket.yAcceleration	= 75;
    rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
    
    rocket.contents			= (id) [[UIImage imageNamed:@"ring"] CGImage];
    rocket.scale			= 0.2;
    rocket.color			= [[UIColor redColor] CGColor];
    rocket.greenRange		= 1.0;		// different colors
    rocket.redRange			= 1.0;
    rocket.blueRange		= 1.0;
    rocket.spinRange		= M_PI;		// slow spin
    
    
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;		// at the end of travel
    burst.velocity			= 0;
    burst.scale				  = 2.5;
    burst.redSpeed			= -1.5;		// shifting
    burst.blueSpeed			= +1.5;		// shifting
    burst.greenSpeed		= +1.0;		// shifting
    burst.lifetime			= 0.35;
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 400;
    spark.velocity			= 125;
    spark.emissionRange		= 2 * M_PI;	// 360 deg
    spark.yAcceleration		= 75;		// gravity
    spark.lifetime			= 3;
    
    spark.contents			= (id) [[UIImage imageNamed:@"star"] CGImage];
    spark.scaleSpeed		= -0.2;
    spark.greenSpeed		= -0.1;
    spark.redSpeed			= 1.0;
    spark.blueSpeed			= -0.2;
    spark.alphaSpeed		= -0.25;
    spark.spin				  = 2* M_PI;
    spark.spinRange			= 2* M_PI;
    
    // putting it together
    _fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
    rocket.emitterCells				= [NSArray arrayWithObject:burst];
    burst.emitterCells				= [NSArray arrayWithObject:spark];
    [self.view.layer addSublayer:_fireworksEmitter];
}

- (void)stopFirework {
    [_fireworksEmitter removeFromSuperlayer];
    _fireworksEmitter = nil;
}

- (void)initCardsWithAlbum:(AlbumType)albumType {
    _cards = [[CardManager defaultManager] allCardsInAlbum:albumType];
}

- (Card *)cardWithId:(NSNumber *)cardId {
    Card * card = nil;
    if (nil != self.cards) {
        NSInteger count = self.cards.count;
        for (NSInteger index = 0; index < count; index++) {
            card = [self.cards objectAtIndex:index];
            if (card.id == cardId) {
                break;
            }
        }
    }
    
    return card;
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

- (IBAction)back:(id)sender {
    
}

@end
