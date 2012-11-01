//
//  HomeViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton * buttonStudy;
@property (weak, nonatomic) IBOutlet UIButton * buttonGame;
@property (weak, nonatomic) IBOutlet UIButton * buttonSet;
@property (weak, nonatomic) IBOutlet UILabel * labelTop;
@property (weak, nonatomic) IBOutlet UILabel * labelBottom;

- (IBAction)startGame:(UIButton *)sender;
- (IBAction)setCard:(UIButton *)sender;
- (IBAction)cardManager:(UIButton *)sender;

- (IBAction)touchDown:(UIButton *)sender;
- (IBAction)touchCancel:(UIButton *)sender;
@end
