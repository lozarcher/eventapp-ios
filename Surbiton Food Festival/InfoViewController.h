//
//  InfoViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 25/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Info.h"
#import "UILabel+MarkupExtensions.h"

@interface InfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *infoTitle;
@property (weak, nonatomic) IBOutlet UILabel *infoContent;
@property (retain,nonatomic) Info *info;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@end
