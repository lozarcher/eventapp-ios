//
//  GalleryViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 03/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface GalleryViewController : UIViewController <MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end
