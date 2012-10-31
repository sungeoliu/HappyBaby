//
//  CardContentViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-29.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardContentViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) Card * card;

@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UIView * viewAnimation;
@property (weak, nonatomic) IBOutlet UIButton * button;
@property (weak, nonatomic) IBOutlet UILabel * label;
@property (weak, nonatomic) IBOutlet UIButton * buttonRecord;
- (id)initWithCard:(Card *) card;
- (void)refreshImage;

- (IBAction)modifyPhoto:(UIButton *)sender;
- (IBAction)recordSound:(UIButton *)sender;
- (IBAction)stopRecordSound:(UIButton *)sender;
- (IBAction)playSound:(UIButton *)sender;

@end
