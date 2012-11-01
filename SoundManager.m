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
    AVAudioRecorder * _audioRecorder;
    NSArray * _systemSoundsArray;
}
@end

@implementation SoundManager

+ (SoundManager *)defaultManager {
    if (nil == sSoundManager) {
        sSoundManager = [[SoundManager alloc] init];
    }
    
    return sSoundManager;
}

- (id)init{
    if (self = [super init]) {
        _systemSoundsArray = [[NSArray alloc] initWithObjects:@"ready",@"right",@"wrong",nil];
    }
    
    return self;
}

- (void)playSound:(NSURL *)sound {
    if (nil == sound) {
        return;
    }

    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sound error:&error];
    _audioPlayer.delegate = self;
    _audioPlayer.numberOfLoops  = 0;
    _audioPlayer.volume = 1;
    if(nil != _audioPlayer) {
        [_audioPlayer play];
    }
}

- (void)stopSound {
    if (nil != _audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
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

- (void)recordSound:(NSURL *)sound {
    NSMutableDictionary * recordSettings = [[NSMutableDictionary alloc] initWithCapacity:0];
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];//格式
    [recordSettings setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey]; //采样8000次
    [recordSettings setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];//声道
    [recordSettings setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];//位深度
    [recordSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [recordSettings setValue :[NSNumber numberWithInt: AVAudioQualityMax]     forKey:AVEncoderAudioQualityKey];
    NSError * recorderError = nil;

    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:sound
                                                     settings:recordSettings error:&recorderError];
    
    if(_audioRecorder) {
        [_audioRecorder record];
    }
    else {
        NSLog(@"recorder: %@ %d %@", [recorderError domain], [recorderError code], [[recorderError userInfo] description]);
    }
}

- (void)stopRecordSound {
    if (nil != _audioRecorder) {
        [_audioRecorder stop];
        NSNotification * notification = nil;
        notification = [NSNotification notificationWithName:kSoundRecordSuccessMessage object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)cancelRecord {
    if (nil != _audioRecorder) {
        [_audioRecorder deleteRecording];
    }
}

- (void)playSystemSound:(SystemSound) sound {
    NSString * fineName = [_systemSoundsArray objectAtIndex:sound];
    NSURL * url = [[NSBundle mainBundle] URLForResource: fineName 
                                         withExtension: @"mp3"];
    [self playSound:url];
}

#pragma AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSNotification * notification = nil;
    notification = [NSNotification notificationWithName:kSoundPlaySuccessMessage object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
