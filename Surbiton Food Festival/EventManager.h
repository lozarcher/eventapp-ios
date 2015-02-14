//
//  EventManager.h
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventManagerDelegate.h"
#import "EventCommunicatorDelegate.h"

@class EventCommunicator;

@interface EventManager : NSObject<EventCommunicatorDelegate>
@property (strong, nonatomic) EventCommunicator *communicator;
@property (weak, nonatomic) id<EventManagerDelegate> delegate;

-(void)fetchEvents;

@end
