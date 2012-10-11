//
//  ObjectManager.h
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "BaseManager.h"
#import "Object.h"

typedef enum {
    AlbumTypeFamily
}AlbumType;

@interface ObjectManager : BaseManager

- (NSArray *)allObjectsInAlbum:(AlbumType) albumType;

- (BOOL)newObjectWithName:(NSString *)name inAlbum:(AlbumType)albumType;
- (BOOL)modifyObject:(NSNumber *)objectId withNewImage:(UIImage *) image;
- (BOOL)modifyObject:(NSNumber *)objectId withNewPronunciation:(NSURL *)url;

@end
