//
//  CardContentViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-29.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "CardContentViewController.h"
#import "CardSetViewController.h"
#import "Feature.h"

@interface CardContentViewController () {
    SoundManager * _soundManager;
    CardManager * _cardManager;
    NSURL * _url;
}

@end

@implementation CardContentViewController
@synthesize card = _card;
@synthesize button = _button;
@synthesize label = _label;
@synthesize imageView  = _imageView;
@synthesize viewAnimation = _viewAnimation;
@synthesize buttonRecord = _buttonRecord;

#pragma 私有函数

-(void)initRecordingImage {
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"recordingSignal001"],
                                      [UIImage imageNamed:@"recordingSignal002"],
                                      [UIImage imageNamed:@"recordingSignal003"],
                                      [UIImage imageNamed:@"recordingSignal004"],
                                      [UIImage imageNamed:@"recordingSignal005"],
                                      [UIImage imageNamed:@"recordingSignal006"],
                                      [UIImage imageNamed:@"recordingSignal007"],
                                      [UIImage imageNamed:@"recordingSignal008"],
                                      nil];
    self.imageView.animationDuration = 1;
}

- (void)showActionSheet {
    UIActionSheet * menu = [[UIActionSheet alloc]
                            initWithTitle:nil delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"相册", @"相机", nil];
    
    [menu showInView:self.parentViewController.view];
}

- (void)playAnimation {
    [_viewAnimation setHidden:NO];
    [self.imageView startAnimating];
}

- (void)stopAnimation {
    [_viewAnimation setHidden:YES];
    [self.imageView stopAnimating];
}

- (void)showPhotoWithType:(UIImagePickerControllerSourceType) type {
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        imagePickerController.sourceType = type;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)initButtonRecord {
    [[Feature defaultFeature] setRadiusWithButon:_buttonRecord];
    [_buttonRecord setBackgroundColor:[UIColor whiteColor]];
}

- (void)initCard {
    if (nil != _card) {
        if (nil != _card.pronunciation) {
            _url = [[NSURL alloc] initWithString:_card.pronunciation];
        }
        [self refreshImage];
    }
}

#pragma 类成员函数
- (id)initWithCard:(Card *) card {
    // load the view nib and initialize the pageNumber ivar
    if (self = [super initWithNibName:@"CardContentViewController" bundle:nil]) {
        _card = card;
        _soundManager = [SoundManager defaultManager];
        _cardManager = [CardManager defaultManager];
    }
    
    return self;
}

- (void)refreshImage {
    if (nil != _card && nil != _card.image) {
        UIImage * image;
        NSURL * url;
        NSData * data;
        url = [[NSURL alloc] initWithString:_card.image];
        data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        [_button setBackgroundImage:image forState:UIControlStateNormal];
        [_button setTitle:@"" forState:UIControlStateNormal];
    }else {
        [_button setBackgroundImage:nil forState:UIControlStateNormal];
        [_button setTitle:@"未设置" forState:UIControlStateNormal];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[Feature defaultFeature] showShadowWithButton:_button];
    [self initRecordingImage];
    [self initCard];
    [self initButtonRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)modifyPhoto:(UIButton *)sender {
    [self showActionSheet];
}

- (IBAction)recordSound:(UIButton *)sender {
    _url = [_cardManager newSoundUrl];
    [_soundManager recordSound:_url];
    [self playAnimation];
    [_buttonRecord setBackgroundColor:[[Feature defaultFeature] pinkColor]];
}

- (IBAction)stopRecordSound:(UIButton *)sender {
    [self stopAnimation];
    [_cardManager modifyCard:_card withPronunciation:_url];
    [_soundManager stopRecordSound];
    [_buttonRecord setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)playSound:(UIButton *)sender {
    if (nil != _card) {
        [_soundManager playSound:_url];
    }
}

#pragma mark - ActionSheet view delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self showPhotoWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if(buttonIndex == 1){
        [self showPhotoWithType:UIImagePickerControllerSourceTypeCamera];
    }
}

#pragma mark - ImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image =  [info valueForKey:UIImagePickerControllerEditedImage];
    //UIImage * resizeImage = [[Feature defaultFeature] getSubImage:image withRect:CGRectMake(0, 0, 316, 368)];
    [_button setBackgroundImage:image forState:UIControlStateNormal];
    [_cardManager modifyCard:_card withImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
