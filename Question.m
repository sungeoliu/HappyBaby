//
//  Question.m
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-18.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "Question.h"
#import "Card.h"

@implementation Question

@synthesize prompt = _prompt;
@synthesize voice = _voice;
@synthesize options = _options;

- (id)initWithAnswerCard:(Card *)card withOptions:(NSArray *)options{
    if (self = [super init]) {
        self.prompt = [NSString stringWithFormat:@"%@ 在哪里？", card.name];
        self.voice = [NSURL URLWithString:card.pronunciation];
        self.options = options;
    }
    
    return self;
}

- (void)debugPrint{
    NSLog(@"question: %@", self.prompt);
    for (int i = 0; i < self.options.count; i++) {
        NSLog(@"option[%d] %d", i, [[self.options objectAtIndex:i] integerValue]);
    }
}

@end
