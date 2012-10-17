//
//  ObjectManager.m
//  HappyBaby
//
//  Created by Liu Wanwei on 12-10-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "CardManager.h"
#import "DocumentManager.h"

static CardManager * sDefaultManager = nil;

@implementation CardManager

// Singleton interface.
+ (CardManager *)defaultManager{
    if (sDefaultManager == nil) {
        sDefaultManager = [[CardManager alloc] init];
    }
    
    return sDefaultManager;
}

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request{
    // query.
    NSError * error = nil;
    NSMutableArray * mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (nil == mutableFetchResult) {
        NSLog(@"allObjectsInAlbum error");
        return nil;
    }
    
    return mutableFetchResult;
}

- (NSArray *)allCardsInAlbum:(AlbumType)albumType{
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:kCardEntity];
    
    // condition.
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumId == %d", albumType];
    request.predicate = predicate;
    
    // sorting.
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject: sortDescriptor];
    
    NSArray * cards =  [self executeFetchRequest:request];
    if (nil != cards && 0 == cards.count) {
        return nil;
    }else{
        return cards;
    }
}

- (Card *)cardWithName:(NSString *)name inAlbum:(AlbumType)album{
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:kCardEntity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"albumId == %d AND name like %@", album, name];
    request.predicate = predicate;
    
    NSArray * results = [self executeFetchRequest:request];
    if (nil == results || 1 != results.count) {
        return nil;
    }else{
        return [results objectAtIndex:0];
    }
}

- (BOOL)newCardWithName:(NSString *)name inAlbum:(AlbumType)albumType{
    // check if this card name already exists.
    if (0 != [self cardWithName:name inAlbum:albumType]) {
        return NO;
    }
    
    Card * card = (Card *)[NSEntityDescription insertNewObjectForEntityForName:kCardEntity inManagedObjectContext:self.managedObjectContext];
    card.id = [BaseManager generateIdForKey:kCardEntity];
    card.name = name;
    card.albumId = [NSNumber numberWithInteger:albumType];
    
    if (! [self synchroniseToStore]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)modifyCard:(Card *)card withImage:(UIImage *)image{
    DocumentManager * documentManager = [DocumentManager defaultManager];
    if (card.image == nil) {
        // image not exist, create a proper name for the image and save it.
        NSURL * storagePath = [documentManager pathForRandomImageWithSuffix:@"png"];
        if(! [documentManager saveImage:image toURL:storagePath]){
            return NO;
        }
        
        card.image = [storagePath absoluteString];
        [super synchroniseToStore];// TODO does this help?
        
        return YES;
    }else{
        // image already exist, occpy the old one.
        NSURL * url = [NSURL URLWithString:card.image];
        return [documentManager saveImage:image toURL:url];
    }
}

- (BOOL)modifyCard:(Card *)card withPronunciation:(NSURL *)url{
    card.pronunciation = [url absoluteString];
    [self synchroniseToStore];
    return NO;
}

- (NSURL *)newSoundUrl{
    DocumentManager * manager = [DocumentManager defaultManager];
    return [manager pathForRandomSoundWithSuffix:@"ma4"];
}

@end
