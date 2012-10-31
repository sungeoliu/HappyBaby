//
//  QuestionModeGameViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseGameViewController.h"

@interface QuestionModeGameViewController : BaseGameViewController

@property(weak, nonatomic) IBOutlet UILabel * labelCountdown;
@property(weak, nonatomic) IBOutlet UIView * viewBackground;

- (IBAction)checkAnswer:(UIButton *)sender;

@end
