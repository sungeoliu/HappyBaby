//
//  QuestionModeGameViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseGameViewController.h"
#import "GameEngine.h"

@interface QuestionModeGameViewController : BaseGameViewController<GameEngineDelegate>

@property(weak, nonatomic) IBOutlet UIButton * button1;
@property(weak, nonatomic) IBOutlet UIButton * button2;
@property(weak, nonatomic) IBOutlet UIButton * button3;
@property(weak, nonatomic) IBOutlet UIButton * button4;
@property(weak, nonatomic) IBOutlet UIButton * button5;
@property(weak, nonatomic) IBOutlet UIButton * button6;
@property(weak, nonatomic) IBOutlet UILabel * label1;
@property(weak, nonatomic) IBOutlet UILabel * label2;
@property(weak, nonatomic) IBOutlet UILabel * label3;
@property(weak, nonatomic) IBOutlet UILabel * label4;
@property(weak, nonatomic) IBOutlet UILabel * label5;
@property(weak, nonatomic) IBOutlet UILabel * label6;
@property(weak, nonatomic) IBOutlet UILabel * labelInfo;

- (IBAction)back:(id)sender;
- (IBAction)checkAnswer:(UIButton *)sender;

@end
