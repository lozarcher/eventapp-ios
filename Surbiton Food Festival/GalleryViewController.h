//
//  GalleryViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 03/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface GalleryViewController : UIViewController <MWPhotoBrowserDelegate, NSURLConnectionDelegate> {
    NSString *storePath;
    NSMutableData *receivedData;
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;

@end
