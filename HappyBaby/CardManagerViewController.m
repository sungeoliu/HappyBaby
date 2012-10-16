//
//  CardManagerViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-13.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "CardManagerViewController.h"
#import "CardAudioRecordViewController.h"
#import "Card.h"

@interface CardManagerViewController () {
    NSNumber * _curSelectCardIndex;
}

@end

@implementation CardManagerViewController

#pragma 私有函数
- (void)initView {
    if (nil != self.cards) {
        NSInteger count = self.cards.count;
        UIImageView * imageView;
        UILabel * label;
        Card * card;
        for (NSInteger index = 0; index < count; index++) {
            imageView = (UIImageView *)[self.view viewWithTag:kImageViewTagOrigin + index];
            label = (UILabel *)[self.view viewWithTag:kLabelTagOrigin + index];
            //FIMX 获取图片
            card = [self.cards objectAtIndex:index];
            //imageView setImage:<#(UIImage *)#>
            label.text = card.name;
        }
    }
}

- (void)showActionSheet {
    UIActionSheet * menu = [[UIActionSheet alloc]
                            initWithTitle:nil delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"相册", @"相机", nil];
    
    [menu showInView:self.view];
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

- (void)showCardAudioRecordView {
    CardAudioRecordViewController * viewController = [[CardAudioRecordViewController alloc] initWithNibName:@"CardAudioRecordViewController" bundle:nil];
    
    CGRect fream = CGRectMake(50.0, 50.0, 350.0, 200.0);
    viewController.view.frame = fream;
    viewController.view.alpha = 0.8;
    
    [self.view addSubview:viewController.view];
    [self addChildViewController:viewController];
}

#pragma 事件函数
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)modifyPhoto:(UIButton *)sender {
    _curSelectCardIndex = [NSNumber numberWithInteger:sender.tag];
    [self showActionSheet];
}

- (IBAction)modifyAudio:(UIButton *)sender {
    [self showCardAudioRecordView];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}
#endif

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
// FIMX 保存图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image =  [info valueForKey:UIImagePickerControllerEditedImage];
    UIImageView * imageView =  (UIImageView *)[self.view viewWithTag:[_curSelectCardIndex integerValue] + kImageViewTagOrigin];
    [imageView setImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
