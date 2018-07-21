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

@interface AWSS3Helper : NSObject

@property (strong, nonatomic) NSString *bucket;
@property (strong, nonatomic) NSString *key;

- (void)uploadAWSFile:(NSURL *)filePath;
- (void)downloadAWSFile:(NSString *)bucket;

@end
