//
//  ObjectManager.m
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "CardManager.h"

static CardManager * sDefaultManager = nil;

@implementation CardManager

// Singleton interface.
+ (CardManager *)defaultManager{
    if (sDefaultManager == nil) {
        sDefaultManager = [[CardManager alloc] init];
    }
    
    return sDefaultManager;
}

- (NSArray *)allCardsInAlbum:(AlbumType)albumType{
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:kCardEntity];
    
    // condition.
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumId == %d", albumType];
    request.predicate = predicate;
    
    // sorting.
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject: sortDescriptor];
    
    // query.
    NSError * error = nil;
    NSMutableArray * mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (nil == mutableFetchResult) {
        NSLog(@"allObjectsInAlbum error");
        return nil;
    }
    
    return mutableFetchResult;
}

- (BOOL)newObjectWithName:(NSString *)name inAlbum:(AlbumType)albumType{
    Card * card = (Card *)[NSEntityDescription insertNewObjectForEntityForName:kCardEntity inManagedObjectContext:self.managedObjectContext];
    card.id = [BaseManager generateIdForKey:kCardEntity];
    card.albumId = [NSNumber numberWithInteger:albumType];
    
    if (! [self synchroniseToStore]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)modifyObject:(NSNumber *)objectId withImage:(UIImage *)image{
    // TODO
    return NO;
}

- (BOOL)modifyObject:(NSNumber *)objectId withPronunciation:(NSURL *)url{
    // TODO
    return NO;
}

@end
