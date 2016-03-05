//
//  CoverHelper.h
//  Surbiton Food Festival
//
//  Created by Loz on 05/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoverHelper : NSObject

-(UIImage *)clipCover:(UIImage *)image fbOffsetX:(NSString *)fbOffsetX fbOffsetY:(NSString *)fbOffsetY ratio:(float)ratio;

@end
