//
//  Feature.m
//  HappyBaby
//
//  Created by maoyu on 12-10-26.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "Feature.h"

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

@end
