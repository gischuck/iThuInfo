//
//  SharedObjects.h
//  iThuInfo
//
//  Created by wenhao on 12-11-30.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "Base64Util.h"
#define thuInfoLoginURL "https://m.tsinghua.edu.cn/Login"
#define thuNetLoginURL "http://usereg.tsinghua.edu.cn/login.php"

@interface SharedObjects : NSObject<NSAlertDelegate>
{
    NSString *userName;
    NSString *userPwd;
    WebView *webView;
    WebView *infoWebView;
    NSWindow *infoWindow;
    NSWindow *mainWin;
    NSWindow *settings;
    NSString *networkStatus;
    NSStatusItem *statusItem;
    NSString *usages;
    NSTextField *currentUsages;
    NSTextField *totalUsages;
    NSString *ipAddress;
    BOOL isLoginNet;
    NSMenuItem *currentUsageMenuItem;
}
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *userPwd;
@property(nonatomic,strong) WebView *webView;
@property(nonatomic,strong) NSWindow *mainWin;
@property(nonatomic,strong) NSString *networkStatus;
@property (nonatomic,strong) NSStatusItem *statusItem;
@property (nonatomic,strong) NSString *usages;
@property (nonatomic,strong) NSTextField *currentUsages;
@property (nonatomic,strong) NSTextField *totalUsages;
@property (nonatomic,strong) NSString *ipAddress;
@property (nonatomic,strong) WebView *infoWebView;
@property (nonatomic,strong) NSWindow *infoWindow;
@property (nonatomic) BOOL isLoginNet;
@property (nonatomic,strong) NSMenuItem *currentUsageMenuItem;
@property (nonatomic,strong) NSWindow *settings;

+ (SharedObjects *) sharedInstance;

- (void) setWebViewByData:(NSString *)value baseURL: (NSString *)url;
//- (void) setInfoWebViewByData:(NSString *)value baseURL: (NSString *)url;
- (void) showMsgWin:(NSString *)msg withDetail:(NSString *)detail inWin: (NSWindow *)win;
- (NSString*) getNetWorkUsage;

-(void)getIPAddress;
@end
