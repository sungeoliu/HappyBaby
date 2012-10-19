//
//  Album.h
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-19.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AlbumTypeFamily = 1,
    AlbumTypeAnimal
}AlbumType;

@interface Album : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic) AlbumType type;

@end
