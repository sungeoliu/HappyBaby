//
//  CardManagerViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-13.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseGameViewController.h"

@interface CardManagerViewController : BaseGameViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (IBAction)modifyPhoto:(UIButton *)sender;
- (IBAction)modifyAudio:(UIButton *)sender;

@end
