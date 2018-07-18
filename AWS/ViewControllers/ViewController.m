//
//  ViewController.m
//  AWS
//
//  Created by Dimitar Danailov on 13.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <AWSMobileClient.h>

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveImageButton;

@property (weak, nonatomic) IBOutlet UITextView *awsIdentity;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveImageButton.enabled = NO;
    [self loadInfoAboutAWSIdentity];
}

- (void)loadInfoAboutAWSIdentity {
    // Get the AWSCredentialsProvider from the AWSMobileClient
    AWSCognitoCredentialsProvider* credentialsProvider = [[AWSMobileClient sharedInstance] getCredentialsProvider];
    
    // Get the identity Id from the AWSIdentityManager
    NSString* identityId = [AWSIdentityManager defaultIdentityManager].identityId;
    [self.awsIdentity setText:identityId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Show Camera

- (IBAction)showCamera:(id)sender {
    NSLog(@"Show camera ...");
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Pick up image

/**
 * Tutorial: https://www.appcoda.com/ios-programming-camera-iphone-app/
 */
- (IBAction)pickImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.saveImageButton.enabled = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.saveImageButton.enabled = NO;
}

#pragma mark - Save image to AWS

- (IBAction)saveImageToAWS:(id)sender {
    [self saveButtonWaitingState];
}

- (void)saveButtonWaitingState {
    self.saveImageButton.enabled = NO;
    [self.saveImageButton setTitle:@"Waiting ..." forState:UIControlStateNormal];
}

@end
