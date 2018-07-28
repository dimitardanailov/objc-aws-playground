//
//  AWSS3BaseHelper.m
//  AWS
//
//  Created by Dimitar Danailov on 28.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <AWSCognito/AWSCognito.h>

#import "AWSS3BaseHelper.h"

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
@implementation AWSS3BaseHelper

static NSString *const IDENTITY_POOL_ID = @"eu-central-1:be93f2d5-fe44-4601-a475-7509344fc452";

- (void)initAWSCognitoConfigs {
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionEUCentral1
                                                          identityPoolId:IDENTITY_POOL_ID];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1 credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}

@end
