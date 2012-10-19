//
//  HappyBabyTests.m
//  HappyBabyTests
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "HappyBabyTests.h"
#import "CardManager.h"
#import "GameEngine.h"
#import "InternalAlbums.h"

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

//- (void)testCardCreation{
//    NSArray * cards = [cardManager allCardsInAlbum:AlbumTypeFamily];
//    STAssertNotNil(cards, @"no cards in AlbumTypeAnimal");
//    NSLog(@"card number: %d", cards.count);
////    BOOL result = [cardManager newCardWithName:@"laolao" inAlbum:AlbumTypeFamily];
////    STAssertTrue(result, @"create laolao failed");
//}
//
//- (void)testCardModification{
//    Card * card = [cardManager cardWithName:@"laolao" inAlbum:AlbumTypeFamily];
//    STAssertNotNil(card, @"card -laolao- not exist");
//    
//    BOOL result = [cardManager modifyCard:card withImage:image];
//    STAssertTrue(result, @"modify card image");
//    
//    NSURL * randomSoundPath = [cardManager newSoundUrl];
//    STAssertNotNil(randomSoundPath, @"random sound path");
//    NSLog(@"sound URL: %@", [randomSoundPath absoluteString]);
//}

- (void)testAlbum{
    InternalAlbums * internalAlbums = [[InternalAlbums alloc] init];
    STAssertNotNil(internalAlbums, nil);
    NSArray * albums = internalAlbums.albums;
    STAssertNotNil(albums, nil);
    
    NSLog(@"%d albums", albums.count);
    for (int i = 0; i < albums.count; i++) {
        Album * album = [albums objectAtIndex:i];
        NSLog(@"album name %@", album.name);
        NSLog(@"album type %d", album.type);
        
        NSArray * cards = [cardManager allCardsInAlbum:album.type];
        NSLog(@"    %d cards in album", cards.count);
        for (int j = 0; j < cards.count; j++) {
            Card * card = [cards objectAtIndex:j];
            NSLog(@"    card id   %d", [card.id integerValue]);
            NSLog(@"    card name %@", card.name);
        }
    }
}

- (void)testGameEngine{
//    NSArray * family = [NSArray arrayWithObjects:@"laolao", @"laoye", @"nainai", @"yeye", @"mama", @"baba", nil];
//    
//    for (int i = 0; i < family.count; i++) {
//        BOOL ret = [cardManager newCardWithName:[family objectAtIndex:i] inAlbum:AlbumTypeFamily];
//        STAssertTrue(ret, nil);
//    }
    
    GameEngine * engine = [[GameEngine alloc] init];
    [engine startGameWithAlbum:AlbumTypeFamily];
    
    NSInteger loop = 4;
    
    NSLog(@"\n一选一");
    for (int i = 0; i < loop; i++) {
        engine.gameMode = GameModeOneOption;
        [engine newQuestion];
        [engine.currentQuestion debugPrint];
    }

    
    NSLog(@"\n二选一");
    for (int i = 0; i < loop; i++) {
        engine.gameMode = GameModeTwoOptions;
        [engine newQuestion];
        [engine.currentQuestion debugPrint];
    }

    NSLog(@"\n三选一");
    for (int i = 0; i < loop; i++) {
        engine.gameMode = GameModeThreeOptions;
        [engine newQuestion];
        [engine.currentQuestion debugPrint];
    }
    
    NSLog(@"\n四选一");
    for (int i = 0; i < loop; i++) {
        engine.gameMode = GameModeFourOptions;
        [engine newQuestion];
        [engine.currentQuestion debugPrint];        
    }
}

@end
