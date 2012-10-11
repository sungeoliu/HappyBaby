//
//  Card.h
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-11.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Card : NSManagedObject

@property (nonatomic, retain) NSNumber * albumId;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pronunciation;

@end
