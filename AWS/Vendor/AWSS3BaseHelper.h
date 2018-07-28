//
//  AWSS3BaseHelper.h
//  AWS
//
//  Created by Dimitar Danailov on 28.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AWSS3/AWSS3.h>

@interface AWSS3BaseHelper: NSObject

@property (strong, nonatomic) NSString *bucket;
@property (strong, nonatomic) NSString *key;
@property (copy, nonatomic) AWSS3TransferUtilityProgressBlock progressBlock;

- (void)initAWSCognitoConfigs;

@end
