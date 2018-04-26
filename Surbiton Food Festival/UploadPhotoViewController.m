//
//  UploadPhotoViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 03/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "MTConfiguration.h"
#import "AppDelegate.h"

@import MobileCoreServices;    // only needed in iOS

@interface UploadPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *captionField;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation UploadPhotoViewController

@synthesize spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _submitButton.hidden = TRUE;
    _nameLabel.hidden = TRUE;
    _nameField.hidden = TRUE;
    _captionField.hidden = TRUE;
    _captionLabel.hidden = TRUE;
    _takePhotoButton.hidden = FALSE;
    _cameraRollButton.hidden = FALSE;
    self.title = NSLocalizedString(@"Upload a Photo", nil);

    self.httpQueue = [[NSOperationQueue alloc] init];
    
    [Answers logContentViewWithName:@"Gallery Upload"
                        contentType:@"Gallery"
                          contentId:@"gallery-upload"
                   customAttributes:@{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)photoButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing=NO;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Can not find Camera Device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (IBAction)cameraRollButtonClicked:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing=NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"Finished picking image");
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    _imageView.image=image;
    _nameLabel.hidden = NO;
    _nameField.hidden = NO;
    _captionLabel.hidden = NO;
    _captionField.hidden = NO;
    _submitButton.hidden=NO;
    _cameraRollButton.hidden = YES;
    _takePhotoButton.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

// method to convert user image to JPEG representation
- (IBAction) uploadPhoto:(id)sender {
    {
        NSData   *imageFileData;
        NSString *imageFileName;
        if ([_nameField.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter your name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        // check if there is an image to upload
        if (self.imageView != nil) {
            // yes, let's convert the image
            // UIImageJPEGRepresentation accepts a UIImage and compression parameter
            // use UIImagePNGRepresentation(self.userImage) for .PNG types
            imageFileData = UIImageJPEGRepresentation(self.imageView.image, 0.33f);
            NSUUID  *UUID = [NSUUID UUID];
            NSString* stringUUID = [UUID UUIDString];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", stringUUID];

            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:_nameField.text forKey:@"name"];
            [params setValue:_captionField.text forKey:@"caption"];
            [params setValue:imageFileName forKey:@"filename"];

            [self uploadToServerUsingImage:imageFileData andFileName:imageFileName andParams:params];
        } else {
            NSLog(@"processImageThenPostToServer:self.userImage IS nil.");
        }
    }
}

// HTTP method to upload file to web server
- (void)uploadToServerUsingImage:(NSData *)imageData andFileName:(NSString *)filename andParams:(NSDictionary*)paramsDict {
    // set this to your server's address
    [self showProgressView:YES];
    NSString *serviceHostname = [MTConfiguration serviceHostname];
    NSString *loadUrl = @"/gallery";
    NSString *urlAsString = [NSString stringWithFormat:@"%@%@", serviceHostname, loadUrl];
    
    NSURL *theURL = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:theURL];
        
    // setting the HTTP method
    [request setHTTPMethod:@"POST"];
        
    // we want a JSON response
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
    // the boundary string. Can be whatever we want, as long as it doesn't appear as part of "proper" fields
    NSString *boundary = @"qqqq___winter_is_coming_!___qqqq";
        
    // setting the Content-type and the boundary
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
    // we need a buffer of mutable data where we will write the body of the request
    NSMutableData *body = [NSMutableData data];
    
    // writing the basic parameters
    for (NSString *key in paramsDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [paramsDict objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
        
    // if we have successfully obtained a NSData representation of the image
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
        NSLog(@"no image data!!!");
        
    // we close the body with one last boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // assigning the completed NSMutableData buffer as the body of the HTTP POST request
    [request setHTTPBody:body];
    
    // send the request
    [NSURLConnection sendAsynchronousRequest:request
                                           queue:self.httpQueue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   NSLog(@"completion handler with response: %@", [NSHTTPURLResponse localizedStringForStatusCode:[(NSHTTPURLResponse*)response statusCode]]);
                                   NSLog(@"response: %li",(long)[(NSHTTPURLResponse*)response statusCode]);
                                   
                                   NSInteger status = [(NSHTTPURLResponse*)response statusCode];
                                   
                                   if(error){
                                       NSLog(@"http request error: %@", error.localizedDescription);
                                       // handle the error
                                       [self performSelectorOnMainThread:@selector(showMessage:)
                                                              withObject:@"Sorry, there was a network error when uploading your photo. Please try later"
                                                           waitUntilDone:YES];
                                       [CrashlyticsKit recordError:error];
                                       
                                   }
                                   else{
                                       if (status == 200) {
                                           NSLog(@"Photo uploaded successfully");
                                           NSLog(@"response %@", response);
                                           [self performSelectorOnMainThread:@selector(showMessage:)
                                                                  withObject:@"Thank you for your photo! It will appear on the gallery shortly"
                                                               waitUntilDone:YES];
                                       }
                                           // handle the success
                                       else {
                                           NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                           [self performSelectorOnMainThread:@selector(showMessage:)
                                                                  withObject:@"Sorry, there was a server error when trying to add your photo. Please try later"
                                                               waitUntilDone:YES];
                                           NSLog(@"Photo did not upload: %@", result);
                                       }
                                   }
                               }];
        
    }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showMessage:(NSString *) message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [self showProgressView:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate.homeViewController loadHome];
}

-(void)showProgressView:(BOOL) activate {
    if (activate) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.hidesWhenStopped = YES;
        CGRect frame = spinner.frame;
        frame.origin.x = self.imageView.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = self.imageView.frame.size.height / 2 - frame.size.height / 2;
        spinner.frame = frame;
        [self.imageView addSubview:spinner];
        [spinner startAnimating];
    } else {
        if (spinner) {
            [spinner stopAnimating];
        }
    }
}

@end
