//
//  CardManagerViewController.m
//  HappyBaby
//
//  Created by maoyu on 12-10-29.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "CardManagerViewController.h"
#import "CardManager.h"
#import "CardContentViewController.h"
#import "Feature.h"
#import "SoundManager.h"

@interface CardManagerViewController () {
    NSArray * _cards;
    NSMutableArray * _viewControllers;
    SoundManager * _soundManager;
    CardManager * _cardManager;
    NSURL * _url;
    NSDate * _dateDown;
    NSDate * _dateUp;
}

@end

@implementation CardManagerViewController
@synthesize albumType = _albumType;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize labelTitle = _labelTitle;
@synthesize viewWarn = _viewWarn;
@synthesize viewAnimation = _viewAnimation;

#pragma 私有函数
- (void)showViewWarn {
    [_viewWarn setHidden:NO];
    [self performSelector:@selector(hideViewWarn) withObject:nil afterDelay:1.5];
}

- (void)hideViewWarn {
    [_viewWarn setHidden:YES];
}

- (BOOL)checkRecordValidity {
    NSTimeInterval interval = [_dateUp timeIntervalSinceDate:_dateDown];
    if (interval < 1) {
        [self performSelector:@selector(showViewWarn) withObject:nil afterDelay:0.5];
        return NO;
    }
    
    return YES;
}

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
        //imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)initButtonRecord {
    [[Feature defaultFeature] setRadiusWithButon:_buttonRecord];
    [_buttonRecord setBackgroundColor:[UIColor whiteColor]];
}

- (void)initCardsWithAlbum:(AlbumType)albumType {
    _cards = [[CardManager defaultManager] allCardsInAlbum:albumType];
}

- (void)setTitleWithPage:(NSInteger) page {
    Card * card = [_cards objectAtIndex:page];
    _labelTitle.text = card.name;
}

- (void)initView {
    _labelTitle.backgroundColor = [[Feature defaultFeature] pinkColor];
    [[Feature defaultFeature] setRadiusWithView:_viewWarn];
    [[Feature defaultFeature] setRadiusWithView:_viewAnimation];
    if (nil != _cards) {
        [self setTitleWithPage:0];
        NSInteger count = _cards.count;
        _viewControllers = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < count; index++) {
            [_viewControllers addObject:[NSNull null]];
        }
        
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * count, _scrollView.frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        
        _pageControl.numberOfPages = count;
        _pageControl.currentPage = 0;
        
        // pages are created on demand
        // load the visible page
        // load the page on either side to avoid flashes when the user starts scrolling
        //
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
    }
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= _cards.count)
        return;
    
    CardContentViewController * controller = [_viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[CardContentViewController alloc] initWithCard:[_cards objectAtIndex:page]];
        [_viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [_scrollView addSubview:controller.view];
        [self addChildViewController:controller];
    }
}

#pragma 事件函数
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _soundManager = [SoundManager defaultManager];
        _cardManager = [CardManager defaultManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRecordingImage];
    [self initCardsWithAlbum:_albumType];
    [self initView];
    [self initButtonRecord];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)modifyPhoto:(UIButton *)sender {
    [self showActionSheet];
}

- (IBAction)recordSound:(UIButton *)sender {
    _url = [_cardManager newSoundUrl];
    [_soundManager recordSound:_url];
    [self playAnimation];
    [_buttonRecord setBackgroundColor:[[Feature defaultFeature] pinkColor]];
    _dateDown = [NSDate date];
}

- (IBAction)stopRecordSound:(UIButton *)sender {
    [self stopAnimation];
    [_soundManager stopRecordSound];
    _dateUp = [NSDate date];
    if (YES == [self checkRecordValidity]) {
        CardContentViewController * controller = [_viewControllers objectAtIndex:_pageControl.currentPage];
        [_cardManager modifyCard:controller.card withPronunciation:_url];
    }
    
    [_buttonRecord setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)playSound:(UIButton *)sender {
    Card * card = [_cards objectAtIndex:_pageControl.currentPage];
    if (nil != card.pronunciation) {
        [_soundManager playSound:[[NSURL alloc] initWithString:card.pronunciation]];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    [self setTitleWithPage:page];
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - ActionSheet view delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [self showPhotoWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if(buttonIndex == 1){
        [self showPhotoWithType:UIImagePickerControllerSourceTypeCamera];
    }
}

#pragma mark - ImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image =  [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage * crropedImage = [[Feature defaultFeature] cropperImage:image withRect:CGRectMake(5,30,310,370)];
    CardContentViewController * controller = [_viewControllers objectAtIndex:_pageControl.currentPage];
    [_cardManager modifyCard:controller.card withImage:crropedImage];
    [controller refreshImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
