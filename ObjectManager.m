//
//  ObjectManager.m
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "ObjectManager.h"

@implementation ObjectManager

- (NSArray *)allObjectsInAlbum:(AlbumType)albumType{
    return nil;
}

- (BOOL)newObjectWithName:(NSString *)name inAlbum:(AlbumType)albumType{
    return NO;
}

- (BOOL)modifyObject:(NSNumber *)objectId withNewImage:(UIImage *)image{
    return NO;
}

- (BOOL)modifyObject:(NSNumber *)objectId withNewPronunciation:(NSURL *)url{
    return NO;
}

@end
