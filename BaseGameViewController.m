//
//  BaseGameViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseGameViewController.h"
#import "Feature.h"

@interface BaseGameViewController () {
    CAEmitterLayer * _fireworksEmitter;
}

@end

@implementation BaseGameViewController

@synthesize labelInfo = _labelInfo;
@synthesize soundManager = _soundManager;
@synthesize question = _question;
@synthesize gameEngine = _gameEngine;
@synthesize gameMode = _gameMode;

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

- (void)setBackgroundColorWithLabel:(UILabel *)label {
    [label setBackgroundColor:[[Feature defaultFeature] pinkColor]];
}

#pragma 类成员函数
- (void)handleGotQuestion:(Question *)question {
    
}

- (void)handleRightAnswerForObject:(NSNumber *)objectId {
    
}

- (void)handleWrongAnswerForObject:(NSNumber *)objectId {
    
}

- (void)handleAnswerTimeout:(NSNumber *)objectId {
    
}

- (void)handleQuestionTimerCountdown:(NSNumber *) secondsLeft {
    
}

- (void)initViewWithOptions:(NSArray *)options{
    if (nil != options) {
        UIImage * image;
        NSURL * url;
        NSData * data;
        NSNumber * cardId;
        Card * card;
        UIButton * button;
        UILabel * label;
        
        NSInteger count = options.count;
        for (NSInteger index = 0; index < count; index++) {
            cardId = [options objectAtIndex:index];
            card = [self cardWithId:cardId];
            
            button = (UIButton *)[self.view viewWithTag:index + 1];
            if (nil != card.image) {
                url = [[NSURL alloc] initWithString:card.image];
                data = [NSData dataWithContentsOfURL:url];
                image = [UIImage imageWithData:data];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                [button setTitle:@"" forState:UIControlStateNormal];
            }else {
                [button setTitle:@"未设置照片，请设置" forState:UIControlStateNormal];
            }
            [[Feature defaultFeature ]showShadowWithButton:button];
            label = (UILabel *)[self.view viewWithTag:-1 - index];
            label.text = card.name;
        }
    }
}

#pragma 事件函数
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _gameEngine = [[GameEngine alloc] init];
        _gameEngine.delegate = self;
        _gameEngine.answerQuestionTimerInterval = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gameEngine.gameMode = self.gameMode;
    [self initCardsWithAlbum:_albumType];
    _soundManager = [SoundManager defaultManager];
    [self setBackgroundColorWithLabel:_labelInfo];
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
    _gameEngine.delegate = nil;
    [_gameEngine stopGame];
    [self.soundManager stopSound];
    [_soundManager stopBackgroundSound];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma GameEngineDelegate
- (void)gotQuestion:(Question *)question {
    self.question = question;
    [self handleGotQuestion:question];
}

- (void)rightAnswerForObject:(NSNumber *)objectId {
    [self handleRightAnswerForObject:objectId];
}

- (void)wrongAnswerForObject:(NSNumber *)objectId {
    [self handleWrongAnswerForObject:objectId];
}

- (void)answerTimeout:(NSNumber *)objectId {
    [self handleAnswerTimeout:objectId];
}

- (void)questionTimerCountdown:(NSNumber *) secondsLeft {
    [self handleQuestionTimerCountdown:secondsLeft];
}

@end
