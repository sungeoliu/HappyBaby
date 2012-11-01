//
//  Feature.h
//  HappyBaby
//
//  Created by maoyu on 12-10-26.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feature : NSObject

+ (Feature *)defaultFeature;

- (UIColor *)pinkColor;
- (void)showShadowWithButton:(UIButton *)button;
- (void)setRadiusWithButon:(UIButton *)button;
- (void)setRadiusWithView:(UIView *)view;

- (UIImage *)cropperImage:(UIImage *)image withRect:(CGRect)rect;
@end
