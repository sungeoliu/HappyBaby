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

- (BOOL)addCard:(NSString *)name withImage:(NSString *)imagePath withSound:(NSString *)soundPath{
    CardManager * manager = [CardManager defaultManager];
    Card * card = [manager newCardWithName:name inAlbum:AlbumTypeFamily];
    if (nil == card) {
        return NO;
    }
    
    if (nil != imagePath) {
        UIImage * image = [UIImage imageNamed:imagePath];
        if(! [manager modifyCard:card withImage:image]){
            return NO;
        }
    }
    
    if (nil != soundPath) {
        NSURL * soundURL = [[NSBundle mainBundle] URLForResource:soundPath withExtension:@"m4a"];
        if (! [manager modifyCard:card withPronunciation:soundURL]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)createFamilyAlbumCard{    
    NSLog(@"createFamilyAlbumCard");
    
    NSArray * descriptions = [NSArray arrayWithObjects:
                              [NSArray arrayWithObjects:@"姥爷", @"laoye", @"where_is_laoye", nil],
                              [NSArray arrayWithObjects:@"姥姥", @"laolao", @"where_is_laolao", nil],
                              [NSArray arrayWithObjects:@"爸爸", @"baba", @"where_is_baba", nil],
                              [NSArray arrayWithObjects:@"妈妈", @"mama", @"where_is_mama", nil],
                              [NSArray arrayWithObjects:@"爷爷", @"yeye", @"where_is_yeye", nil],
                              [NSArray arrayWithObjects:@"奶奶", @"nainai", @"where_is_nainai", nil],nil];
    
    for (NSArray * singleDescription in descriptions) {
        [self addCard:[singleDescription objectAtIndex:0]
            withImage:[singleDescription objectAtIndex:1]
            withSound:[singleDescription objectAtIndex:2]];
    }

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
