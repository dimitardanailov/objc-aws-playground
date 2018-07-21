//
//  ViewController.m
//  AWS
//
//  Created by Dimitar Danailov on 13.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <AWSMobileClient.h>

#import "ViewController.h"
#import "AWSS3Helper.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveImageButton;

@property (weak, nonatomic) IBOutlet UIButton *downalodImageButton;

@property (weak, nonatomic) IBOutlet UITextView *awsIdentity;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSDictionary *pickerDictonary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveImageButton.enabled = NO;
    // self.downalodImageButton.enabled = NO;
    
    [self loadInfoAboutAWSIdentity];
}

- (void)loadInfoAboutAWSIdentity {
    // Get the AWSCredentialsProvider from the AWSMobileClient
    AWSCognitoCredentialsProvider* credentialsProvider = [[AWSMobileClient sharedInstance] getCredentialsProvider];
    NSLog(@"amazon credentials: %@", credentialsProvider);
    
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
    
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
         [self openCamera];
     } else {
         [self displayErrorDialogCameraDoesntExist];
     }
}

- (void)openCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)displayErrorDialogCameraDoesntExist {
    UIAlertController * alert = [UIAlertController
                                alertControllerWithTitle:@"Camera is missing !!!"
                                message:@"Emulator doesn't have a camera"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Please use a real device"
                                style:UIAlertActionStyleDefault
                                handler:nil];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    self.pickerDictonary = info;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self saveButtonNormalState];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.saveImageButton.enabled = NO;
}

#pragma mark - Save image to AWS

- (IBAction)saveImageToAWS:(id)sender {
    [self saveButtonWaitingState];
    [self uploadImageToAWS];
}

- (void)uploadImageToAWS {
    NSURL *imagePath = [self.pickerDictonary objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *imageName = [imagePath lastPathComponent];
    NSLog(@"image name %@",imagePath);
    
    // NSLog(@"Filename %@", [self.pickerDictonary objectForKey:@"UIImagePickerControllerImageURL"]);
    
    AWSS3Helper *aws = [[AWSS3Helper alloc] init];
    aws.bucket = @"awsplaygroundobjc-deployments-mobilehub-818149808";
    aws.key = imageName;
    
    NSURL *filePath = [self.pickerDictonary objectForKey:@"UIImagePickerControllerImageURL"];
    NSLog(@"filepath %@", filePath);
    
    [aws uploadAWSFile:filePath];
}

# pragma mark - Download image to AWS

- (IBAction)downloadImageToAWS:(id)sender {
    AWSS3Helper *aws = [[AWSS3Helper alloc] init];
    
    [aws downloadAWSFile: nil];
}

#pragma mark - States of save buttons

- (void)saveButtonWaitingState {
    self.saveImageButton.enabled = NO;
    [self.saveImageButton setTitle:@"Waiting ..." forState:UIControlStateDisabled];
}

- (void)saveButtonNormalState {
    self.saveImageButton.enabled = YES;
    [self.saveImageButton setTitle:@"Save image" forState:UIControlStateNormal];
}

@end
