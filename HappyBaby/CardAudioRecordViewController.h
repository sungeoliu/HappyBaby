//
//  CradAudioRecordViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-15.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Card;

@interface CardAudioRecordViewController : UIViewController

@property (strong, nonatomic) Card * card;

- (IBAction)recordSound:(UIButton *)sender;
- (IBAction)stopRecordSound:(UIButton *)sender;
- (IBAction)playSound:(UIButton *)sender;
- (IBAction)save:(UIButton *)sender;
- (IBAction)close:(UIButton *)sender;

@end
