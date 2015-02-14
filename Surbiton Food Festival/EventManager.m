//
//  EventManager.m
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "EventManager.h"
#import "EventCommunicator.h"
#import "EventBuilder.h"

@implementation EventManager
-(void)fetchEvents {
    NSLog(@"EventManager: Fetching events");
    [self.communicator getEvents];
}

# pragma mark - EventCommunicatorDelegate

-(void)receivedEventsJSON:(NSData *)objectNotation {
    NSError *error = nil;
    NSArray *events = [EventBuilder eventsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingEventsFailedWithError:error];
        
    } else {
        [self.delegate didReceiveEvents:events];
    }
}

- (void)fetchingEventsFailedWithError:(NSError *)error
{
    [self.delegate fetchingEventsFailedWithError:error];
}
@end
