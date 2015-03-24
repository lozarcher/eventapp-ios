//
//  VoucherViewController.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 28/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface VoucherViewController : GAITrackedViewController {
    UIImage* image;
}
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *tappedImage;
- (id)initWithImage:(UIImage *)anImage;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
