//
//  EventViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 15/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

@synthesize eventTitleLabel, eventDateLabel, eventImageView, eventDescriptionLabel, closeButton, event;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)closeButtonPressed:(id)sender {
       [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    eventTitleLabel.text = event.name;
    eventDescriptionLabel.text = event.desc;
    NSTimeInterval seconds = [event.startTime doubleValue]/1000;
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mma";
    NSString *dateText = [dateFormatter stringFromDate:startDate];
    if (endDate != nil) {
        NSString *endDateString = [dateFormatter stringFromDate:endDate];
        NSArray* dates = [[NSArray alloc] initWithObjects:dateText, endDateString, nil];
        dateText = [dates componentsJoinedByString:@" - "];
    }
    eventDateLabel.text = dateText;
    
    if (![event.coverUrl isKindOfClass:[NSNull class]]) {

        NSString *urlString = [[event coverUrl]  stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
        NSLog(@"Event cover URL: %@", urlString);
        NSLog(@"Event cover URL: %lu bytes", (unsigned long)[imageData length]);
        eventImageView.frame = self.view.bounds;

        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [event coverUrl]]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                [eventImageView setImage:[UIImage imageWithData: data]];
            });
         });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
