//
//  HomeViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) UISegmentedControl * segmentedControl;

- (IBAction)startGame:(UIButton *)sender;
- (IBAction)setCard:(UIButton *)sender;
- (IBAction)gameModeChanged:(UISegmentedControl *)sender;
@end
