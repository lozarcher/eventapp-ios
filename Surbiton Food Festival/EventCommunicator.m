//
//  EventCommunicator.m
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "EventCommunicator.h"
#import "EventCommunicatorDelegate.h"

@implementation EventCommunicator

-(void)getEvents {
    NSLog(@"EventCommunicator: Getting events");

    NSString *urlAsString = @"http://localhost:8080/events";
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingEventsFailedWithError:error];
        } else {
            [self.delegate receivedEventsJSON:data];
        }
    }];
}

@end
