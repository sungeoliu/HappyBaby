//
//  BaseGameViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardManager.h"

typedef enum {
    AnswerStateWait,
    AnswerStateTimeout,
    AnswerStateRight,
    AnswerStateWrong
}AnswerState;

#define kCardSize  6
#define kImageViewTagOrigin 6
#define kLabelTagOrigin 12

@interface BaseGameViewController : UIViewController

@property (weak, nonatomic)  NSArray * cards;
@property (nonatomic) AlbumType albumType;
@property (nonatomic) AnswerState answerState;

- (void)initCardsWithAlbum:(AlbumType)albumType;
- (void)shakeView:(UIButton *)view;
- (IBAction)back:(id)sender;
@end
