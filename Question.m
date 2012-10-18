//
//  Question.m
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-18.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "Question.h"

@implementation Question

@synthesize prompt = _prompt;
@synthesize voice = _voice;
@synthesize options = _options;

- (id)initWithPrompt:(NSString *)prompt withVoice:(NSURL *)voice withOptions:(NSArray *)options{
    if (self = [super init]) {
        self.prompt = prompt;
        self.voice = voice;
        self.options = options;
    }
    
    return self;
}

@end
