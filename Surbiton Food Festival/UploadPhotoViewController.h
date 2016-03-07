//
//  UploadPhotoViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 03/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIImage *image;
@property (nonatomic, weak) NSString *name;
@property (nonatomic, strong) NSOperationQueue *httpQueue;
@end
