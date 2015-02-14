//
//  EventManagerDelegate.h
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventManagerDelegate
-(void)didReceiveEvents:(NSArray *)events;
-(void)fetchingEventsFailedWithError:(NSError *)error;

@end
