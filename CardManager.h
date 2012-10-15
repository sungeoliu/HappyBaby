//
//  ObjectManager.h
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseManager.h"
#import "Card.h"

#define kCardEntity    @"Card"

typedef enum {
    AlbumTypeFamily,
    AlbumTypeAnimal
}AlbumType;

@interface CardManager : BaseManager

+ (CardManager *)defaultManager;

- (NSArray *)allCardsInAlbum:(AlbumType) albumType;

- (BOOL)newCardWithName:(NSString *)name inAlbum:(AlbumType)albumType;
- (BOOL)modifyCard:(Card *)card withImage:(UIImage *) image;
- (BOOL)modifyCard:(Card *)card withPronunciation:(NSURL *)url;

- (NSURL *)newSoundUrl;

@end
