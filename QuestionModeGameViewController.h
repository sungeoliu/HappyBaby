//
//  QuestionModeGameViewController.h
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseGameViewController.h"
#import "GameEngine.h"

@interface QuestionModeGameViewController : BaseGameViewController<GameEngineDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(weak, nonatomic) IBOutlet UILabel * labelInfo;
@property(weak, nonatomic) IBOutlet UILabel * labelCountdown;
@property(weak, nonatomic) IBOutlet UIButton * buttonAudioPlay;
@property(weak, nonatomic) IBOutlet UIButton * buttonAudioRecord;
@property(weak, nonatomic) IBOutlet UIButton * buttonEdit;
@property(weak, nonatomic) IBOutlet UIButton * buttonPhoto;
@property(weak, nonatomic) IBOutlet UIImageView * imageViewPhoto;
@property(weak, nonatomic) IBOutlet UIView * viewBackground;

@property(nonatomic) GameMode gameMode;

- (IBAction)playAudioPlay:(UIButton *)sender;
- (IBAction)checkAnswer:(UIButton *)sender;
- (IBAction)newCard:(UIButton *)sender;
- (IBAction)editCard:(UIButton *)sender;
- (IBAction)modifyPhoto:(UIButton *)sender;
- (IBAction)modifyAudio:(UIButton *)sender;

@end
