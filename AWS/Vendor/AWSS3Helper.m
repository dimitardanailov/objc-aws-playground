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

static NSString *const FILE_TYPE = @"image/jpeg";

- (instancetype)init
{
    if (self) {
        [self initAWSCognitoConfigs];
    }
    
    return self;
}

# pragma mark - AWS Upload

/**
 * Source: https://github.com/awslabs/aws-sdk-ios-samples/blob/master/S3TransferUtility-Sample/Objective-C/S3BackgroundTransferSampleObjC/FirstViewController.m
 */
- (void)uploadAWSFile:(NSURL *)filePath   {
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.progressBlock = self.progressBlock;
    
    [self initAWSCognitoConfigs];
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility uploadFile:filePath
                          bucket:self.bucket
                             key:self.key
                     contentType:FILE_TYPE
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

/**
 * Source: 
 */
- (void)downloadAWSFile {
    // Create a temp location to store file
    NSString *downloadingFilePath =
        [[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"] stringByAppendingPathComponent:self.key];
    
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadingFilePath]) {
        // return downloadingFileURL;
    } else {
        AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
        // downloadRequest.bucket = S3BucketName;
        // downloadRequest.key = s3Object.key;
        // downloadRequest.downloadingFileURL = downloadingFileURL;
    }
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
