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
    [self initAWSCognitoConfigs];
    
    return self;
}

- (void)uploadAWSFile:(NSURL *)filePath {
    AWSS3TransferManagerUploadRequest *uploadRequest = [self createAWSS3UploadRequest:filePath];
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
       withBlock:^id(AWSTask *task) {
           if (task.error) {
               if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                   switch (task.error.code) {
                       case AWSS3TransferManagerErrorCancelled:
                       case AWSS3TransferManagerErrorPaused:
                           break;
                           
                       default:
                           NSLog(@"Error: %@", task.error);
                           break;
                   }
               } else {
                   // Unknown error.
                   NSLog(@"Error: %@", task.error);
               }
           }
           
           if (task.result) {
               AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
               // The file uploaded successfully.
               NSLog(@"The file uploaded successfully. %@", uploadOutput);
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

- (AWSS3TransferManagerUploadRequest *)createAWSS3UploadRequest:(NSURL *)filePath {
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    
    uploadRequest.bucket = self.bucket;
    uploadRequest.key = self.key;
    uploadRequest.body = filePath;
    
    NSLog(@"Filepath: %@", self.key);
    
    return uploadRequest;
}

@end
