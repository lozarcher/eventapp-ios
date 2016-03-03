//
//  GalleryBuilder.m
//  IYAF 2015
//
//  Created by Loz Archer on 29/05/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "GalleryBuilder.h"
#import "Gallery.h"

@implementation GalleryBuilder
+ (NSArray *)galleryFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *galleries = [[NSMutableArray alloc] init];
    NSArray *results = [parsedObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *eventDic in results) {
        Gallery *gallery = [[Gallery alloc] init];
        
        for (NSString *key in eventDic) {
            if ([gallery respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                [gallery setValue:[eventDic valueForKey:key] forKey:mappedKey];
            }
        }
        
        [galleries addObject:gallery];
    }
    
    return galleries;
}

@end
