//
//  MyBusiness.h
//  iThuInfo
//
//  Created by wenhao on 12-11-30.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MD5Encryption.h"
#import "SharedObjects.h"
#import "HttpHelper.h"
#import "ThreadJobs.h"

@interface MyBusiness : NSObject
{
    SharedObjects *mySharedData;
    NSMutableData *webData;
    NSInteger _method;
    NSString *_userName;
    NSString *_userPwd;
    BOOL isLoginInfo;
    BOOL isLoginNet;
    BOOL isLoginWebInfo;
    ThreadJobs *checkJobs;
}

- (void)changeWebInfoView:(NSString *)userName withPwd:(NSString *)pwd withMethod:(NSInteger)method;

@end
