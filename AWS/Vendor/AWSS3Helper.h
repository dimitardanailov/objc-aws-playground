//
//  AWSS3Helper.h
//  AWS
//
//  Created by Dimitar Danailov on 17.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>

@interface AWSS3Helper: NSObject

@property (strong, nonatomic) NSString *bucket;
@property (strong, nonatomic) NSString *key;
@property (copy, nonatomic) AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler;
@property (copy, nonatomic) AWSS3TransferUtilityProgressBlock progressBlock;

- (void)uploadAWSFile:(NSURL *)filePath;
- (void)downloadAWSFile;

@end
