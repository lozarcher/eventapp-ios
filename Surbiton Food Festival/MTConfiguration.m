#import "MTConfiguration.h"

#define MTEnvironmentName @"environmentName"
#define MTServiceHostname @"serviceHostname"

@interface MTConfiguration ()

@property (copy, nonatomic) NSString *configuration;
@property (nonatomic, strong) NSDictionary *variables;

@end

@implementation MTConfiguration

#pragma mark -
#pragma mark Shared Configuration
+ (MTConfiguration *)sharedConfiguration {
    static MTConfiguration *_sharedConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfiguration = [[self alloc] init];
    });
    
    return _sharedConfiguration;
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Fetch Current Configuration
        NSBundle *mainBundle = [NSBundle mainBundle];
        self.configuration = [[mainBundle infoDictionary] objectForKey:@"Configuration"];
        
        // Load Configurations
        NSString *path = [mainBundle pathForResource:@"Configurations" ofType:@"plist"];
        NSDictionary *configurations = [NSDictionary dictionaryWithContentsOfFile:path];
        
        // Load Variables for Current Configuration
        self.variables = [configurations objectForKey:self.configuration];
    }
    
    return self;
}

#pragma mark -
+ (NSString *)configuration {
    return [[MTConfiguration sharedConfiguration] configuration];
}

#pragma mark -
+ (NSString *)environmentName {
    MTConfiguration *sharedConfiguration = [MTConfiguration sharedConfiguration];
    
    if (sharedConfiguration.variables) {
        return [sharedConfiguration.variables objectForKey:MTEnvironmentName];
    }
    
    return nil;
}
+ (NSString *)serviceHostname {
    MTConfiguration *sharedConfiguration = [MTConfiguration sharedConfiguration];
    
    if (sharedConfiguration.variables) {
        return [sharedConfiguration.variables objectForKey:MTServiceHostname];
    }
    
    return nil;
}
@end