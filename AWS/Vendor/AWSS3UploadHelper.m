//
//  AWSS3Helper.m
//  AWS
//
//  Created by Dimitar Danailov on 17.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <AWSS3/AWSS3.h>

#import "AWSS3UploadHelper.h"

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
@implementation AWSS3UploadHelper

static NSString *const FILE_TYPE = @"image/jpeg";

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self initAWSCognitoConfigs];
    }
    
    return self;
}

/**
 * Source: https://github.com/awslabs/aws-sdk-ios-samples/blob/master/S3TransferUtility-Sample/Objective-C/S3BackgroundTransferSampleObjC/FirstViewController.m
 */
- (void)uploadAWSFile:(NSURL *)filePath   {
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.progressBlock = self.progressBlock;
    
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

@end
