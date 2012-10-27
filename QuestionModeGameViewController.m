//
//  QuestionModeGameViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "QuestionModeGameViewController.h"
#import "SoundManager.h"
#import "CardAudioRecordViewController.h"

@interface QuestionModeGameViewController () {
    GameEngine * _gameEngine;
    SoundManager * _soundManager;
    NSInteger  _curSelectCardIndex;
    NSNumber * _curSelectCardId;
    NSArray * _options;
    Question * _question;
    BOOL _isEdit;
}

@end

@implementation QuestionModeGameViewController
@synthesize labelCountdown = _labelCountdown;
@synthesize labelInfo = _labelInfo;
@synthesize buttonAudioPlay = _buttonAudioPlay;
@synthesize buttonAudioRecord = _buttonAudioRecord;
@synthesize buttonEdit = _buttonEdit;
@synthesize buttonPhoto = _buttonPhoto;
@synthesize imageViewPhoto = _imageViewPhoto;
@synthesize viewBackground = _viewBackground;

#pragma 私有函数
- (void)showAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

}
// 检查卡片图片、录音是否进行设置
- (BOOL)checkCards {
    return YES;
    if (nil != self.cards) {
        NSInteger count = self.cards.count;
        Card * card;
        for (NSInteger index = 0; index < count; index++) {
            card = [self.cards objectAtIndex:index];
            if (nil == card.image || nil == card.pronunciation) {
                [self showAlert];
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)initViewWithOptions:(NSArray *)options{
    if (nil != options) {
        _options = options;
        UIImage * image;
        NSURL * url;
        NSData * data;
        NSNumber * cardId;
        Card * card;
        UIButton * button;
        UILabel * label;
        
        NSInteger count = options.count;
        for (NSInteger index = 0; index < count; index++) {
            cardId = [options objectAtIndex:index];
            card = [self cardWithId:cardId];
            
            button = (UIButton *)[self.view viewWithTag:index + 1];
            [self showShadowWithButton:button];
            if (nil != card.image) {
                url = [[NSURL alloc] initWithString:card.image];
                data = [NSData dataWithContentsOfURL:url];
                image = [UIImage imageWithData:data];
                [button setBackgroundImage:image forState:UIControlStateNormal];
            }
            
            label = (UILabel *)[self.view viewWithTag:-1 - index];
            label.text = card.name;
        }
    }
}

- (NSInteger)buttonTagWithCardId:(NSNumber *)cardId {
    if (nil != _options) {
        NSInteger count = _options.count;
        for (NSInteger index = 0; index < count; index++) {
            if (cardId == [_options objectAtIndex:index]) {
                return index + 1;
            }
        }
    }
    
    return 0;
}

- (void)shakeWithButtonTag:(NSInteger)tagId {
    UIButton * button = (UIButton *)[self.view viewWithTag:tagId];
    [self shakeView:button];
}

- (void)registerHandleMessage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:kSoundPlaySuccessMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRecordSucessMessage:) name:kSoundRecordSuccessMessage object:nil];
}

- (void)handleMessage:(NSNotification *)note {
    switch (self.answerState) {
        case AnswerStateRight:
        case AnswerStateTimeout:
            [self stopFirework];
            [_gameEngine newQuestion];
            break;
        case AnswerStateReady:
        default:
            break;
    }
}

- (void)handleRecordSucessMessage:(NSNotification *)note {
    [self initCardsWithAlbum:self.albumType];
     Card * card =  [self cardWithId:[_question.options objectAtIndex:0]];
    _question.voice = [[NSURL alloc] initWithString:card.pronunciation];
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
    
    Card * card =  [self cardWithId:[_question.options objectAtIndex:0]];
    viewController.card = card;
    
    //CGRect fream = CGRectMake(15.0, 100.0, 284.0, 230.0);
    //viewController.view.frame = fream;
    //viewController.view.alpha = 1;
    
    [self.view addSubview:viewController.view];
    [self.view addSubview:_viewBackground];
    [self addChildViewController:viewController];
}

#pragma 事件函数
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _gameEngine = [[GameEngine alloc] init];
        _gameEngine.delegate = self;
        _soundManager = [SoundManager defaultManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gameEngine.answerQuestionTimerInterval = 10;
    _gameEngine.gameMode = self.gameMode;
    _isEdit = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self checkCards]) {
        self.answerState = AnswerStateReady;
        [_gameEngine startGameWithAlbum:self.albumType];
        [_gameEngine newQuestion];

        [_soundManager playBackgroundSound];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerHandleMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    _gameEngine.delegate = nil;
    [_gameEngine stopGame];
    [_soundManager stopSound];
    [_soundManager stopBackgroundSound];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkAnswer:(UIButton *)sender {
    if (nil != _options) {
        _curSelectCardIndex = sender.tag;
        _curSelectCardId = [_options objectAtIndex:sender.tag - 1 ];
        [_gameEngine checkAnswer:_curSelectCardId];
    }
}

- (IBAction)playAudioPlay:(UIButton *)sender {
    [_soundManager playSound:_question.voice];
}

- (IBAction)newCard:(UIButton *)sender {
    [_gameEngine newQuestion];
}

- (IBAction)editCard:(UIButton *)sender {
    if (NO == _isEdit) {
        [_buttonEdit setTitle:@"完成" forState:UIControlStateNormal];
        [_buttonPhoto setHidden:NO];
        [_imageViewPhoto setHidden:NO];
        [_buttonAudioRecord setHidden:NO];
        [_soundManager stopBackgroundSound];
    }else {
        [_buttonEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [_buttonPhoto setHidden:YES];
        [_imageViewPhoto setHidden:YES];
        [_buttonAudioRecord setHidden:YES];
        [_soundManager playBackgroundSound];
    }
    
    _isEdit = !_isEdit;
}

- (IBAction)modifyPhoto:(UIButton *)sender {
    [self showActionSheet];
}

- (IBAction)modifyAudio:(UIButton *)sender {
    [self showCardAudioRecordView];
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma GameEngineDelegate
- (void)gotQuestion:(Question *)question {
    if (nil != question) {
        [self.labelInfo setText:question.prompt];
    }
    _question = question;
    if (nil != question.voice) {
        [_soundManager playSound:question.voice];
    }
  
    [self initViewWithOptions:question.options];
    self.answerState = AnswerStateWait;
}

- (void)rightAnswerForObject:(NSNumber *)objectId {
    [self playFirework];
    self.answerState = AnswerStateRight;
    [_soundManager playSystemSound:SystemSoundRight];
}

- (void)wrongAnswerForObject:(NSNumber *)objectId {
    self.answerState = AnswerStateWrong;
    [_soundManager playSystemSound:SystemSoundWrong];
    [self shakeWithButtonTag:_curSelectCardIndex];
}

- (void)answerTimeout:(NSNumber *)objectId {
    if (_gameMode == GameModeOneOption) {
        return;
    }
    self.answerState = AnswerStateTimeout;
    [_soundManager playSystemSound:SystemSoundWrong];
    [self shakeWithButtonTag:[self buttonTagWithCardId:objectId]];
}

- (void)questionTimerCountdown:(NSNumber *) secondsLeft {
    _labelCountdown.text = [secondsLeft stringValue];
}

#pragma AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self back:nil];
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
    UIButton  * button =  (UIButton *)[self.view viewWithTag:1];
    [button setImage:image forState:UIControlStateNormal];
    Card * card =  [self cardWithId:[_question.options objectAtIndex:0]];
    [[CardManager defaultManager] modifyCard:card withImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
