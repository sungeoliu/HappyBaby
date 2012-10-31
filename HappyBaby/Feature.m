//
//  Feature.m
//  HappyBaby
//
//  Created by maoyu on 12-10-26.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "Feature.h"
#import <QuartzCore/CoreAnimation.h>

static Feature * sDefaultFeatures;

@implementation Feature

+ (Feature *)defaultFeature{
    if (nil == sDefaultFeatures) {
        sDefaultFeatures = [[Feature alloc] init];
    }
    
    return sDefaultFeatures;
}

- (UIColor *) pinkColor {
    return [[UIColor alloc] initWithRed:0.968 green:0.294 blue:0.407 alpha:1.0];
}

- (void)showShadowWithButton:(UIButton *)button {
    button.layer.masksToBounds = NO;
    button.layer.shouldRasterize = YES;
    button.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    button.layer.shadowOpacity = 0.7;
    button.layer.shadowColor =  [UIColor blackColor].CGColor;
}

- (void)setRadiusWithButon:(UIButton *)button {
    button.layer.masksToBounds = NO;
    button.layer.cornerRadius = 8.0f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor =  [UIColor whiteColor].CGColor;
}

- (void)setRadiusWithView:(UIView *)view {
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 8.0f;
}

// 按照宽高比为1.3的比例取值
- (UIImage *)cropperImage:(UIImage *)image withRect:(CGRect)rect {
    UIGraphicsBeginImageContext(CGSizeMake(320, 416));
    [image drawInRect:CGRectMake(0, 0, 320, 416)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef cr = CGImageCreateWithImageInRect([newImage CGImage], rect);
    UIImage * cropped = [UIImage imageWithCGImage:cr];
    CGImageRelease(cr);
    return cropped;
}

@end
