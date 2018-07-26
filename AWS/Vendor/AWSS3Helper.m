//
//  AWSS3Helper.m
//  AWS
//
//  Created by Dimitar Danailov on 17.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>

#import "AWSS3Helper.h"

@interface AWSS3Helper()

@end

/**
 * iOS: Amazon S3 TransferManager for iOS
 * https://docs.aws.amazon.com/aws-mobile/latest/developerguide/how-to-ios-s3-transfermanager.html
 *
 * How to Integrate Your Existing Bucket
 * https://docs.aws.amazon.com/aws-mobile/latest/developerguide/how-to-integrate-an-existing-bucket.html
 *
 * AWS mobile
 * https://docs.aws.amazon.com/aws-mobile/latest/developerguide/getting-started.html
 *
 */
@implementation AWSS3Helper

- (instancetype)init
{
    if (self) {
        [self initAWSCognitoConfigs];
    }
    
    return self;
}

# pragma mark - AWS Upload

/**
 * Source: https://github.com/awslabs/aws-sdk-ios-samples/blob/master/S3TransferManager-Sample/Objective-C/S3TransferManagerSample/UploadViewController.m
 */
- (void)uploadAWSFile:(NSURL *)filePath   {
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.progressBlock = self.progressBlock;
    
    [self initAWSCognitoConfigs];
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility uploadFile:filePath
                          bucket:self.bucket
                             key:self.key
                     contentType:@"image/jpeg"
                      expression:expression
               completionHandler:self.completionHandler] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"AWS Error: %@", task.error);
            NSLog(@"AWS localizedDescription Error: %@", task.error.localizedDescription);
        }
        if (task.result) {
            NSLog(@"AWS task.result %@", task.result);
        }
        
        return nil;
    }];
}

# pragma mark - AWS Download

- (void)downloadAWSFile:(NSString *)bucket {
    AWSS3GetPreSignedURLRequest *getPreSignedURLRequest = [AWSS3GetPreSignedURLRequest new];
    getPreSignedURLRequest.bucket = @"awsplaygroundobjc-deployments-mobilehub-818149808";
    getPreSignedURLRequest.key = @"asset.JPG";
    getPreSignedURLRequest.HTTPMethod = AWSHTTPMethodGET;
    getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:3600];
    
    [[[AWSS3PreSignedURLBuilder defaultS3PreSignedURLBuilder] getPreSignedURL:getPreSignedURLRequest]
     continueWithBlock:^id(AWSTask *task) {
         
         if (task.error) {
             NSLog(@"Error: %@",task.error);
         } else {
             
             NSURL *presignedURL = task.result;
             NSLog(@"download presignedURL is: \n%@", presignedURL);
             
             NSURLRequest *request = [NSURLRequest requestWithURL:presignedURL];
             // self.downloadTask = [self.session downloadTaskWithRequest:request];
             //downloadTask is an instance of NSURLSessionDownloadTask.
             //session is an instance of NSURLSession.
             // [self.downloadTask resume];
             
         }
         return nil;
     }];
}

#pragma mark - Private

- (void)initAWSCognitoConfigs {
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionEUCentral1
                                                          identityPoolId:@"eu-central-1:be93f2d5-fe44-4601-a475-7509344fc452"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1 credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}
@end
