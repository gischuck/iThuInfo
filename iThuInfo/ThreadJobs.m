//
//  ThreadJobs.m
//  iThuInfo
//
//  Created by wenhao on 12-12-2.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import "ThreadJobs.h"
static ThreadJobs *_threadJobs;

@implementation ThreadJobs
- (id) init
{
	if (self = [super init])
	{
        ThreadGetCurrentUsages = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
        lockCondition = [[NSCondition alloc] init];
        mySharedData = [SharedObjects sharedInstance];
        _isLoginNet = [mySharedData isLoginNet];
        [ThreadGetCurrentUsages setName:@"CheckCurrentUsage"];
        [ThreadGetCurrentUsages start];
	}
	return self;
}

+ (ThreadJobs *)ThreadInstance
{
    if (!_threadJobs)
	{
		_threadJobs = [[ThreadJobs alloc] init];
	}
	return _threadJobs;
}

- (void)run{
    while (TRUE) {
        // 上锁
        [lockCondition lock];
        if(_isLoginNet)
        {
            NSImage *originImg = [[mySharedData statusItem] image];
            [[mySharedData statusItem]setImage:[NSImage imageNamed:@"heart"]];
            
            
            
            NSString *url = [NSString stringWithFormat:@"http://usereg.tsinghua.edu.cn/online_user_ipv4.php"];
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000); 
            NSString *returnString = [HttpHelper getHtml:url Encoding:enc];

            //NSLog(@"%@",returnString);
            if ([returnString rangeOfString:@"请登录"].length > 0) {
                NSString *postString = [[NSString alloc]initWithFormat:@"action=login&user_login_name=%@&user_password=%@",[mySharedData userName], [MD5Encryption md5by32:[mySharedData userPwd]]];
                
                url = [NSString stringWithFormat:@"http://usereg.tsinghua.edu.cn/do.php"];
                [HttpHelper getHtmlbyPost:url withPostData:postString];
                url = [NSString stringWithFormat:@"http://usereg.tsinghua.edu.cn/online_user_ipv4.php"];
                returnString = [HttpHelper getHtml:url Encoding:enc];
            }
            if ([returnString rangeOfString:@"ok"].length > 0){
                //检查当前流量
                [self checkUsages:returnString];
            }
            else
            {
                [[mySharedData currentUsageMenuItem]setHidden:YES];
            }
            [[mySharedData statusItem]setImage:originImg];
            //NSLog(@"thread process");
            
            
            //间隔时间
            [NSThread sleepForTimeInterval:30];
        }
        //解锁
        [lockCondition unlock];
    }
}

- (void)checkUsages:(NSString *)str
{
    NSRange range = [str rangeOfString:[mySharedData ipAddress]];
    if (range.length > 0) {
        NSUInteger index = range.location;
        NSString *tmp = [str substringWithRange:NSMakeRange(index, 500)];
        tmp = [tmp stringByReplacingOccurrencesOfString:@"</td>" withString:@""];
        tmp = [tmp stringByReplacingOccurrencesOfString:@"<td class=\"maintd\">" withString:@"@"];
        tmp = [tmp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *arr = [tmp componentsSeparatedByString:@"@"];
        [[mySharedData currentUsages] setStringValue:[arr objectAtIndex:1]];
        [[mySharedData currentUsageMenuItem] setTitle:[[NSString alloc]initWithFormat:@"%@:%@", NSLocalizedString(@"Current_Usage", @"Current Usage"),[arr objectAtIndex:1]]];
        [[mySharedData currentUsageMenuItem]setHidden:NO];
    }
}

@end
