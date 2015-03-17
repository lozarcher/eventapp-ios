//
//  EventViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 15/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "EventViewController.h"
#import "UIImageView+WebCache.h"
#import <EventKit/EventKit.h>
#import "VenueViewController.h"

@interface EventViewController ()


// The database with calendar events and reminders
@property (strong, nonatomic) EKEventStore *eventStore;
// Indicates whether app has access to event store.
@property (nonatomic) BOOL isAccessToEventStoreGranted;
// The data source for the table view
@property (strong, nonatomic) NSMutableArray *todoItems;
@property (strong, nonatomic) EKCalendar *calendar;
@property (copy, nonatomic) NSArray *reminders;

@end

@implementation EventViewController

@synthesize eventTitleLabel, eventDateLabel, eventImageView, eventDescriptionLabel, closeButton, event, eventTimeLabel, venueLabel, remindMeButton, deleteReminderButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (void)updateAuthorizationStatusToAccessEventStore {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Reminders." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            __weak EventViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                });
                                            }];
            break;
        }
    }
}

- (IBAction)closeButtonPressed:(id)sender {
       [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Check to see if we are running on iOS 6
    if (![self respondsToSelector:@selector(topLayoutGuide)]) {
        for (NSLayoutConstraint *constraint in self.topConstraint) {
            constraint.constant = constraint.constant - 64;
        }
    }
    
    [remindMeButton setHidden:NO];
    [deleteReminderButton setHidden:YES];
    
    // Do any additional setup after loading the view from its nib.
    eventTitleLabel.text = event.name;
    if (![[event desc] isKindOfClass:[NSNull class]]) {
        eventDescriptionLabel.text = event.desc;
    } else {
        eventDescriptionLabel.text = @"";
    }
    if (![[event location] isKindOfClass:[NSNull class]]) {
        venueLabel.text = event.location;
    } else {
        venueLabel.text = @"Surbiton";
    }
    
    NSTimeInterval startSeconds = [event.startTime doubleValue]/1000;
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:startSeconds];
    NSDate *endDate = nil;
    if ([event.endTime isKindOfClass:[NSNull class]]) {
        endDate = nil;
    } else {
        NSTimeInterval endSeconds = [event.endTime doubleValue]/1000;
        endDate = [[NSDate alloc] initWithTimeIntervalSince1970:endSeconds];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee d MMMM yyyy"];
    eventDateLabel.text = [dateFormatter stringFromDate:startDate];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeText = [dateFormatter stringFromDate:startDate];
    if (endDate != nil) {
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *endDateString = [dateFormatter stringFromDate:endDate];
        NSArray* dates = [[NSArray alloc] initWithObjects:timeText, endDateString, nil];
        timeText = [dates componentsJoinedByString:@" - "];
    }
    eventTimeLabel.text = timeText;
    eventImageView.frame = self.view.bounds;

    if (![event.coverUrl isKindOfClass:[NSNull class]]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:[event coverUrl]] options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                [eventImageView setImage:image];
                            }];
    } else {
        [eventImageView setImage:[UIImage imageNamed:@"logo.jpg"]];
    }
    
    
    if (![event.venue isKindOfClass:[NSNull class]]) {
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(mapButtonPressed:)];
        self.navigationItem.rightBarButtonItem = mapButton;
    }

    [self updateAuthorizationStatusToAccessEventStore];
    [self fetchReminders];

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

- (EKCalendar *)calendar {
    if (!_calendar) {
        
        // 1
        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
        
        // 2
        NSString *calendarTitle = @"Surbiton Food Festival";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
        
        if ([filtered count]) {
            _calendar = [filtered firstObject];
        } else {
            
            // 3
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
            _calendar.title = @"Surbiton Food Festival";
            _calendar.source = self.eventStore.defaultCalendarForNewReminders.source;
            
            // 4
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
                // Handle error
            }
        }
    }
    return _calendar;
}

- (NSDateComponents *)dateComponentsForDefaultDueDate:(NSString *)startTimeStr {
    NSTimeInterval startSeconds = [startTimeStr doubleValue]/1000;

    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:startSeconds];

    NSDateComponents *oneDayComponents = [[NSDateComponents alloc] init];
    oneDayComponents.day = 1;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *startDateComponents = [gregorianCalendar components:unitFlags fromDate:startDate];
    return startDateComponents;
}

- (IBAction)addReminder:(id)sender {
    NSLog(@"Remind me pressed %@", [event name]);
    
    [self updateAuthorizationStatusToAccessEventStore];

    
    // 1
    if (!self.isAccessToEventStoreGranted)
        return;
    
    // 1
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", [event name]];
    NSArray *results = [self.reminders filteredArrayUsingPredicate:predicate];
    if ([results count]) {
        NSString *message = @"You have already added this reminder!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alertView show];
        [self updateReminderButton];
        return;
    }
    
    // 2
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = [event name];
    reminder.calendar = self.calendar;
    reminder.dueDateComponents = [self dateComponentsForDefaultDueDate:[event startTime]];

    
    NSTimeInterval alarmSeconds = ([[event startTime] doubleValue]/1000) - 60*60;
    NSDate *alarmDate = [[NSDate alloc] initWithTimeIntervalSince1970:alarmSeconds];
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:alarmDate];
    [reminder addAlarm:alarm];
    
    // 3
    NSError *error = nil;
    BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
    if (!success) {
        // Handle error.
    } else {
        [self fetchReminders];
    }
    
    // 4
    NSString *message = (success) ? @"Reminder was successfully added!" : @"Failed to add reminder!";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
    [alertView show];
    
    [self updateReminderButton];

}


- (void)fetchReminders {
    [self updateAuthorizationStatusToAccessEventStore];

    if (self.isAccessToEventStoreGranted) {
        // 1
        NSPredicate *predicate =
        [self.eventStore predicateForRemindersInCalendars:@[self.calendar]];
        
        // 2
        [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
            // 3
            self.reminders = reminders;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 4
                // TODO - Update label whether a reminder is set or not
                [self updateReminderButton];
            });
        }];
    }
}

- (IBAction)deleteReminder {
    // 1
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", [event name]];
    NSArray *results = [self.reminders filteredArrayUsingPredicate:predicate];
    
    // 2
    if ([results count]) {
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error = nil;
            // 3
            BOOL success = [self.eventStore removeReminder:obj commit:YES error:&error];
            if (!success) {
                return;
            } else {
                [self fetchReminders];
                NSString *message = (success) ? @"Reminder was successfully deleted!" : @"Failed to delete reminder!";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alertView show];
                [self updateReminderButton];
            }
        }];
    } else {
        NSString *message = @"There is no reminder to delete!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alertView show];
        [self updateReminderButton];
    }
}

-(void)updateReminderButton {
    [self fetchReminders];
    BOOL hasReminder = [self eventHasReminder];
    [remindMeButton setHidden:hasReminder];
    [deleteReminderButton setHidden:!hasReminder];
}

-(BOOL)eventHasReminder {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", [event name]];
    NSArray *results = [self.reminders filteredArrayUsingPredicate:predicate];
    return [results count];
}

- (IBAction)mapButtonPressed:(id)sender {
    VenueViewController *venueVc = [[VenueViewController alloc] initWithNibName:@"VenueViewController" bundle:nil];
    [self presentViewController:venueVc animated:YES completion:nil];
    [venueVc createVenue:event.venue location:event.location];
}

@end
