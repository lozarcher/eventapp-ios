//
//  UploadPhotoViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 03/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import "UploadPhotoViewController.h"

@interface UploadPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation UploadPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _submitButton.hidden = TRUE;
    _nameLabel.hidden = TRUE;
    _nameField.hidden = TRUE;
    _takePhotoButton.hidden = FALSE;
    _cameraRollButton.hidden = FALSE;
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
    _submitButton.hidden=NO;
    _cameraRollButton.hidden = YES;
    _takePhotoButton.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadPhoto:(id)sender {

    /* creating path to document directory and appending filename with extension */
    
    NSUUID  *UUID = [NSUUID UUID];
    NSString* fileName = [NSString stringWithFormat:@"%@.jpg", [UUID UUIDString]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSData *file1Data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    // NSString *urlString = @”http://www.yourserver.com/applink/fileup.php&#8221;;
    NSString *urlString = @"http://www.yourserver.com/applink/fileup.php&#8221";
    
    /* creating URL request to send data */
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"—————————14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /* adding content as a body to post */
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *header = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\".%@\"\r\n",[fileName stringByDeletingPathExtension],[fileName pathExtension]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n–%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithString:header] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:file1Data]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n–%@–\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] ;
    NSLog(@"return string =%@",returnString);

    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
