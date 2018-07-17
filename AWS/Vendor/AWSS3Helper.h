//
//  AWSS3Helper.h
//  AWS
//
//  Created by Dimitar Danailov on 17.07.18.
//  Copyright © 2018 Dimitar Danailov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AWSS3Helper : NSObject

- (NSString *)bucket;
- (NSString *)key;
- (NSURL *) fileUrl;


@end
