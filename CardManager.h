//
//  ObjectManager.h
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//
//  在游戏中，卡片主要属性：
//  1, 名字［不可修改］
//  2, 图像［可修改］
//  3, 读音［可修改］
//  在提问时，提问发音由问题和卡片名字组合起来，比如问题：
//  “［小朋友］（可以是孩子名字），［兔子］在哪里”，
//  中括号内都是唯一确定的声音对象。
//

#import "BaseManager.h"
#import "Card.h"

#define kCardEntity    @"Card"

typedef enum {
    AlbumTypeFamily = 1,
    AlbumTypeAnimal
}AlbumType;

@interface CardManager : BaseManager

+ (CardManager *)defaultManager;

- (NSArray *)allCardsInAlbum:(AlbumType) albumType;
- (Card *)cardWithName:(NSString *)name inAlbum:(AlbumType)album;

- (BOOL)newCardWithName:(NSString *)name inAlbum:(AlbumType)albumType;
- (BOOL)modifyCard:(Card *)card withImage:(UIImage *) image;
- (BOOL)modifyCard:(Card *)card withPronunciation:(NSURL *)url;

- (NSURL *)newSoundUrl;

@end
