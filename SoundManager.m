//
//  SoundManager.m
//  HappyBaby
//
//  Created by maoyu on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "SoundManager.h"

static SoundManager *sSoundManager;

@interface SoundManager() {
    AVAudioPlayer * _backgroundAudioPlayer;
    AVAudioPlayer * _audioPlayer;
}
@end

@implementation SoundManager

+ (SoundManager *)defaultManager {
    if (nil == sSoundManager) {
        sSoundManager = [[SoundManager alloc] init];
    }
    
    return sSoundManager;
}

- (NSString *) documentsPath {
    NSString * path;
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [searchPaths objectAtIndex: 0];
    
    return path;
}

- (NSString *)filePath:(NSString *)fileName {
    return [[self documentsPath] stringByAppendingPathComponent:fileName];
}

- (void)playSound:(NSURL *)sound {
    if (nil == sound) {
        return;
    }

    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sound error:&error];
    _audioPlayer.delegate = self;
    _audioPlayer.numberOfLoops  = 0;
    _audioPlayer.volume = 0.5;
    if(nil != _audioPlayer) {
        [_audioPlayer play];
    }
}

- (void)playBackgroundSound {
    NSURL *url = [[NSBundle mainBundle] URLForResource: @"backgroundMusic"
                                         withExtension: @"mp3"];
    NSError  *error;
    _backgroundAudioPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _backgroundAudioPlayer.numberOfLoops  = -1;
    _backgroundAudioPlayer.volume = 0.4;
    if (nil != _backgroundAudioPlayer) {
         [_backgroundAudioPlayer  play];
    }
}

- (void)stopBackgroundSound {
    if (nil != _backgroundAudioPlayer) {
        [_backgroundAudioPlayer stop];
    }
}

#pragma AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSNotification * notification = nil;
    notification = [NSNotification notificationWithName:kSoundPlaySuccessMessage object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
