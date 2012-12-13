//
//  SharedObjects.m
//  iThuInfo
//
//  Created by wenhao on 12-11-30.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import "SharedObjects.h"

@implementation SharedObjects

@synthesize networkStatus;
@synthesize userName;
@synthesize userPwd;
@synthesize webView;
@synthesize mainWin;
@synthesize statusItem;
@synthesize usages;
@synthesize currentUsages;
@synthesize totalUsages;
@synthesize ipAddress;
@synthesize infoWebView;
@synthesize infoWindow;
@synthesize isLoginNet;
@synthesize currentUsageMenuItem;
@synthesize settings;

static SharedObjects *_sharedInstance;

- (id) init
{
	if (self = [super init])
	{
		// custom initialization
        NSString *Path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
        Path = [Path stringByAppendingFormat:@"/iThuInfo"];
        BOOL isDirectory = NO;
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:Path isDirectory:&isDirectory];
        if (!exists) {
            [[NSFileManager defaultManager] createDirectoryAtPath:Path withIntermediateDirectories:YES attributes:nil error:nil];
        }        
        
        NSString *filename = [Path stringByAppendingPathComponent:@"userInfo.cfg"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        
        [self setUserName:[arr objectAtIndex:0]];
        [self setUserPwd:[Base64Util decodeBase64:[arr objectAtIndex:1]]];
        [self getIPAddress];
	}
	return self;
}

+ (SharedObjects *) sharedInstance
{
	if (!_sharedInstance)
	{
		_sharedInstance = [[SharedObjects alloc] init];
	}
    
	return _sharedInstance;
}


- (void) setWebViewByData:(NSString *)value  baseURL: (NSString *)url
{
    [[webView mainFrame]loadHTMLString:value baseURL:[NSURL URLWithString:url]];
}
//- (void) setInfoWebViewByData:(NSString *)value baseURL: (NSString *)url
//{
//    [[infoWebView mainFrame]loadHTMLString:value baseURL:[NSURL URLWithString:url]];
//}
- (void) showMsgWin:(NSString *)msg withDetail:(NSString *)detail inWin: (NSWindow *)win
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert setMessageText:detail];
    [alert setInformativeText:msg];
    [alert addButtonWithTitle:@"OK"];
        [alert beginSheetModalForWindow:win
                       modalDelegate:self      
                         didEndSelector:@selector(DiscardAlertDidEnd:returnCode:
                                                  contextInfo:)
                            contextInfo:nil];
}
- (void)DiscardAlertDidEnd:(NSAlert *)alert
                returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    //NSLog (@"Button %d clicked",returnCode);
}

- (NSString*) getNetWorkUsage
{
    if (usages.length > 0) {
        NSArray *arr = [usages componentsSeparatedByString:@","];
        NSInteger u = [[arr objectAtIndex:2] integerValue];
        NSString *tmp;
        if (u > 1e9) {
            tmp = [[NSString alloc]initWithFormat:@"%5.2lf G", u/1e9];
        } else if (u > 1e6) {
            tmp = [[NSString alloc]initWithFormat:@"%5.2lf M", u/1e6];
        } else if (u > 1e3) {
            tmp = [[NSString alloc]initWithFormat:@"%5.2lf K", u/1e3];
        } else {
            tmp = [[NSString alloc]initWithFormat:@"%5.2ld B", u];
        }
        return tmp;
    }
    else
    {
        return NULL;
    }
}

-(void) getIPAddress{
    NSArray *addresses = [[NSHost currentHost] addresses];
    
    for (NSString *anAddress in addresses) {
        if (![anAddress hasPrefix:@"127"] && [[anAddress componentsSeparatedByString:@"."] count] == 4) {
            ipAddress = anAddress;
            break;
        } else {
            ipAddress = @"IPv4 address not available" ;
        }
    }
    //NSLog (@"getIPWithNSHost: stringAddress = %@ ",ipAddress);
    
}
@end
