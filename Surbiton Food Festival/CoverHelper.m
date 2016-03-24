//
//  CoverHelper.m
//  IYAF 2015
//
//  Created by Loz Archer on 03/06/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "CoverHelper.h"

@implementation CoverHelper

-(UIImage *)clipCover:(UIImage *)image fbOffsetX:(NSString *)fbOffsetX fbOffsetY:(NSString *)fbOffsetY ratio:(float)coverRatio {
    CGSize originalSize = [image size];
    float offsetXpc = [fbOffsetX floatValue] / 100 * 0.5;
    float offsetYpc = [fbOffsetY floatValue] / 100 * 0.5;
    
    float offsetX = offsetXpc * originalSize.width;
    float width = originalSize.width - offsetX;
    float offsetY = offsetYpc * originalSize.height;
    float height = originalSize.height - offsetY;
    
    NSLog(@"Original image size %f %f", image.size.width, image.size.height);
    NSLog(@"Offset X Y %f %f", offsetX, offsetY);
    NSLog(@"New width / height %f %f", width, height);

    if (width / height < coverRatio) {
        //too high
        height = width / coverRatio;
    } else {
        if (width / height > coverRatio) {
            //too wide
            width = height * coverRatio;
        }
    }
    NSLog(@"New width / height after adjustment for ratio %f %f", width, height);
    
    CGRect cropRect = CGRectMake(offsetX, offsetY, width, height);
    NSLog(@"CGRectMake offsetX/Y %f %f width height %f %f", offsetX, offsetY, width, height);
    
    UIGraphicsBeginImageContext(cropRect.size);
    [image drawAtPoint:CGPointMake(-offsetX, -offsetY)];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    //UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    return croppedImage;
}

@end

