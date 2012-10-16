//
//  SoundManager.h
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define kSoundPlaySuccessMessage  @"kSoundPlaySuccess"

@interface SoundManager : NSObject <AVAudioPlayerDelegate>

+ (SoundManager *)defaultManager;

- (void)playSound:(NSURL *)sound;
- (void)playBackgroundSound;
- (void)stopBackgroundSound;

- (void)recordSound:(NSURL *)sound;
- (void)stopRecordSound;

@end
