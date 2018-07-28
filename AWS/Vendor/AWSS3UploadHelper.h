//
//  AWSS3Helper.h
//  AWS
//
//  Created by Dimitar Danailov on 17.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSS3/AWSS3.h>

#import "AWSS3BaseHelper.h"

@interface AWSS3UploadHelper : AWSS3BaseHelper

@property (copy, nonatomic) AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler;

- (void)uploadAWSFile:(NSURL *)filePath;

@end
