#import <Foundation/Foundation.h>

@interface MTConfiguration : NSObject

#pragma mark -
+ (NSString *)configuration;

#pragma mark -
+ (NSString *)environmentName;
+ (NSString *)serviceHostname;

@end