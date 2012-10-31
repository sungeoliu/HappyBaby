//
//  CardManagerViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-29.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface CardManagerViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic) AlbumType albumType;

@property (weak, nonatomic) IBOutlet UIScrollView * scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl * pageControl;
@property (weak, nonatomic) IBOutlet UILabel * labelTitle;
@property (weak, nonatomic) IBOutlet UIButton * buttonRecord;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UIView * viewAnimation;
@property (weak, nonatomic) IBOutlet UIView * viewWarn;

- (IBAction)back:(UIButton *)sender;
- (IBAction)modifyPhoto:(UIButton *)sender;
- (IBAction)recordSound:(UIButton *)sender;
- (IBAction)stopRecordSound:(UIButton *)sender;
- (IBAction)playSound:(UIButton *)sender;

@end
