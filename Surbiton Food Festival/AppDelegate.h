//
//  AppDelegate.h
//  Surbiton Food Festival
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h> 
#import "HomeViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) HomeViewController *homeViewController;

@end

