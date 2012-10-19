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
#define AlbumCreatedKey  @"AlbumIsCreated"

@interface InternalAlbums(){
    NSMutableArray * _realAlbums;
}

@end

@implementation InternalAlbums
@synthesize albums = _albums;

- (void)createFamilyAlbumCard{    
    NSLog(@"createFamilyAlbumCard");
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
}

- (id)init{
    if (self = [super init]) {
        // 防止多线程并发调用创建专辑内容。
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 保证App从安装到卸载只执行一次。现已修改成只支持中文！没有多语言切换的问题了。
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL isCreated = [userDefaults boolForKey:AlbumCreatedKey];
            
            if (!isCreated) {
                [self newAlbumWithName:AlbumString(@"AlbumTypeFamilyName") withType:AlbumTypeFamily];
                [self createFamilyAlbumCard];
                
                [userDefaults setBool:YES forKey:AlbumCreatedKey];
            }
        });

    }
    
    return self;
}

- (NSArray *)albums{
    return _realAlbums;
}

@end
