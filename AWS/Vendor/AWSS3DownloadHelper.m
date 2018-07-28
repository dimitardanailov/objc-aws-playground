//
//  AWSS3DownloadHelper.m
//  AWS
//
//  Created by Dimitar Danailov on 28.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import "AWSS3DownloadHelper.h"

@implementation AWSS3DownloadHelper

/**
 * Source: https://github.com/awslabs/aws-sdk-ios-samples/blob/master/S3TransferUtility-Sample/Objective-C/S3BackgroundTransferSampleObjC/SecondViewController.m
 */
- (void)downloadAWSFile {
    AWSS3TransferUtilityDownloadExpression *expression = [AWSS3TransferUtilityDownloadExpression new];
    expression.progressBlock = self.progressBlock;
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility downloadDataFromBucket:self.bucket
                                         key:self.key
                                  expression:expression
                           completionHandler:self.completionHandler] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Downloading...");
            });
        }
        
        return nil;
    }];
}

@end
