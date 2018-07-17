//
//  AWSS3Helper.m
//  AWS
//
//  Created by Dimitar Danailov on 17.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSS3/AWSS3.h>

#import "AWSS3Helper.h"

@interface AWSS3Helper()

@property (strong, nonatomic) AWSS3TransferManager *transferManager;

@end

@implementation AWSS3Helper

- (instancetype)init
{
    self.transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    return self;
}

/**
 * https://docs.aws.amazon.com/aws-mobile/latest/developerguide/how-to-ios-s3-transfermanager.html
 */
- (void)createAWSS3UploadRequest:(NSString *)filePath {
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    
    uploadRequest.bucket = self.bucket;
    uploadRequest.key = self.key;
    
    NSURL *uploadingFileURL = [NSURL fileURLWithPath:filePath];
    uploadRequest.body = uploadingFileURL;
}

@end
