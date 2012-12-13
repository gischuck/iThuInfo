//
//  ThreadJobs.h
//  iThuInfo
//
//  Created by wenhao on 12-12-2.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedObjects.h"
#import "MD5Encryption.h"
#import "HttpHelper.h"

@interface ThreadJobs : NSObject
{
    NSThread *ThreadGetCurrentUsages;
    NSCondition *lockCondition;
    BOOL _isLoginNet;
    SharedObjects *mySharedData;
}

+(ThreadJobs *)ThreadInstance;

@end
