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
typedef enum {
    SystemSoundReady = 0,
    SystemSoundRight = 1,
    SystemSoundWrong = 2
}SystemSound;

@interface SoundManager : NSObject <AVAudioPlayerDelegate>

+ (SoundManager *)defaultManager;

- (void)playSound:(NSURL *)sound;
- (void)stopSound;
- (void)playBackgroundSound;
- (void)stopBackgroundSound;

- (void)recordSound:(NSURL *)sound;
- (void)stopRecordSound;
- (void)cancelRecord;

- (void)playSystemSound:(SystemSound) sound;

@end
