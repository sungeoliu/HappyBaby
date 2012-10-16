//
//  HappyBabyTests.m
//  HappyBabyTests
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "HappyBabyTests.h"
#import "CardManager.h"

@interface HappyBabyTests(){
    CardManager * cardManager;
    UIImage * image;
}

@end

@implementation HappyBabyTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    cardManager = [CardManager defaultManager];
    STAssertNotNil(cardManager, @"create cardManager failed");
    
    // bundle in test case.
    NSString * directBundlePath = [[NSBundle bundleForClass:[self class]] resourcePath];
    NSString * imagePath = [directBundlePath stringByAppendingPathComponent:@"Add@2x.png"];
    image = [UIImage imageWithContentsOfFile:imagePath];
    STAssertNotNil(image, @"load image -add-");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCardCreation{
    NSArray * cards = [cardManager allCardsInAlbum:AlbumTypeFamily];
    STAssertNotNil(cards, @"no cards in AlbumTypeAnimal");
    NSLog(@"card number: %d", cards.count);
//    BOOL result = [cardManager newCardWithName:@"laolao" inAlbum:AlbumTypeFamily];
//    STAssertTrue(result, @"create laolao failed");
}

- (void)testCardModification{
    Card * card = [cardManager cardWithName:@"laolao" inAlbum:AlbumTypeFamily];
    STAssertNotNil(card, @"card -laolao- not exist");
    
    BOOL result = [cardManager modifyCard:card withImage:image];
    STAssertTrue(result, @"modify card image");
    
    NSURL * randomSoundPath = [cardManager newSoundUrl];
    STAssertNotNil(randomSoundPath, @"random sound path");
    NSLog(@"sound URL: %@", [randomSoundPath absoluteString]);
}

@end
