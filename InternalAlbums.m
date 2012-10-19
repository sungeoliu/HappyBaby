//
//  InternalAlbum.m
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-19.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "InternalAlbums.h"
#import "Album.h"
#import "LMLibrary.h"
#import "CardManager.h"

#define AlbumString(x) NSLocalizedStringFromTable(x, @"Album", nil)

@interface InternalAlbums(){
    NSMutableArray * _realAlbums;
}

@end

@implementation InternalAlbums
@synthesize albums = _albums;

- (void)createFamilyAlbumCard{
    AlbumType type = AlbumTypeFamily;
    CardManager * cardManager = [CardManager defaultManager];
    
    [cardManager newCardWithName:AlbumString(@"CardMama") inAlbum:type];
    [cardManager newCardWithName:AlbumString(@"CardPapa") inAlbum:type];
    [cardManager newCardWithName:AlbumString(@"CardLaolao") inAlbum:type];
    [cardManager newCardWithName:AlbumString(@"CardLaoye") inAlbum:type];
    [cardManager newCardWithName:AlbumString(@"CardNainai") inAlbum:type];
    [cardManager newCardWithName:AlbumString(@"CardYeye") inAlbum:type];
}

- (void)newAlbumWithName:(NSString *)name withType:(AlbumType)type{
    if (_realAlbums == nil) {
        _realAlbums = [[NSMutableArray alloc] init];
    }
    
    // 第一个专辑：家庭。
    Album * album;
    album = [[Album alloc] init];
    album.type = type;
    album.name = name;
    [_realAlbums addObject:album];
    
    // TODO 只执行一次。
    [self createFamilyAlbumCard];
}

- (id)init{
    if (self = [super init]) {
        [self newAlbumWithName:AlbumString(@"AlbumTypeFamilyName") withType:AlbumTypeFamily];
    }
    
    return self;
}

- (NSArray *)albums{
    return _realAlbums;
}

@end
