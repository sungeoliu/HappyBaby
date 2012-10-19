//
//  QuestionModeGameViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseGameViewController.h"
#import "GameEngine.h"

@interface QuestionModeGameViewController : BaseGameViewController<GameEngineDelegate,UIAlertViewDelegate>

@property(weak, nonatomic) IBOutlet UILabel * labelInfo;
@property(weak, nonatomic) IBOutlet UILabel * labelCountdown;

@property(nonatomic) GameMode gameMode;

- (IBAction)checkAnswer:(UIButton *)sender;
- (IBAction)newCard:(UIButton *)sender;

@end
