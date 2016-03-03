//
//  GalleryBuilder.h
//  IYAF 2015
//
//  Created by Loz Archer on 29/05/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GalleryBuilder : NSObject

+ (NSArray *)galleryFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end