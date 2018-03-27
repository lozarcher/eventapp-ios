#import "TwitterViewController.h"
#import <TwitterKit/TWTRKit.h>
#import "AppDelegate.h"

@implementation TwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString *twitterSearchTerm = [mainBundle objectForInfoDictionaryKey:@"Twitter Search Term"];
    self.dataSource = [[TWTRSearchTimelineDataSource alloc] initWithSearchQuery:twitterSearchTerm APIClient:client];

    NSString *hashtag = [mainBundle objectForInfoDictionaryKey:@"Hashtag"];
    NSString *title = [NSString stringWithFormat:@"%@ Tweets", hashtag];
    self.title = NSLocalizedString(title, nil);

    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;

}

-(void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(loadHome:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
}

-(void)loadHome:(id)sender {
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate.homeViewController loadHome];
}

@end

