//
//  MainController.m
//  iThuInfo
//
//  Created by wenhao on 12-11-30.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import "MainController.h"

@implementation MainController

@synthesize mainView;
@synthesize mainWindow;

- (void)awakeFromNib
{
    isInNewWin = NO;
    //[self.tabView setDelegate:self];
    [self.tabView selectTabViewItemAtIndex:0];
    bussiness = [[MyBusiness alloc]init];
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    [_statusItem setImage:[NSImage imageNamed:@"stopplay"]];
    [_statusItem setToolTip:NSLocalizedString(@"App_Name", "App Name")];
    [_statusItem setHighlightMode:YES];
    [_statusItem setMenu:[self statusMenu]];

    mySharedData = [SharedObjects sharedInstance];
    [mySharedData setWebView:self.webView];
    [mySharedData setMainWin:self.mainWindow];
    [mySharedData setStatusItem:_statusItem];
    [mySharedData setCurrentUsages:[self currentUsages]];
    [mySharedData setTotalUsages:[self totalUsages]];
    [mySharedData setInfoWindow:[self infoWindow]];
    [mySharedData setInfoWebView:[self infoWebView]];
    [mySharedData setCurrentUsageMenuItem:[self currentUsageMenuItem]];
    [mySharedData setSettings:[self settingsSheet]];
    NSString *ip = [[NSString alloc]initWithFormat:@"%@:%@",NSLocalizedString(@"IP_Address", "IP Address"),[mySharedData ipAddress]];
    [[self ipAddressField]setStringValue:ip];
    
//    if ([mySharedData userName].length < 1) {
//        [NSApp beginSheet:[self settingsSheet] modalForWindow:[self mainWindow] modalDelegate:self didEndSelector:NULL contextInfo:NULL];
//    }
}

- (void)dealloc
{
	[[NSStatusBar systemStatusBar] removeStatusItem:_statusItem];
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    if ([tabView indexOfTabViewItem:tabViewItem] == 0) {
        NSLog(@"netgate");
    }else if ([tabView indexOfTabViewItem:tabViewItem] == 1) {
        [bussiness changeWebInfoView:[mySharedData userName] withPwd:[mySharedData userPwd] withMethod:1];
        NSLog(@"infoview");
        
    }
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    activeWebView = sender;
    if (isInNewWin) {
 
    }
    /*可行的js
     "var script = document.createElement('script'); "
     " script.type = 'text/javascript'; $(document).ready(function(){$(\"a.btn_close\").toggle();});"
    */
    isInNewWin = NO;
    
    //[[self exWebViewer] stringByEvaluatingJavaScriptFromString: @"myFun();"];
    [[self exWinprogressIndicator] stopAnimation:self];
    [[self mainWinprogressIndicator] stopAnimation:self];
    [[self webinfoProgressbar] stopAnimation:self];
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    [[self exWinprogressIndicator] startAnimation:self];
    [[self mainWinprogressIndicator] startAnimation:self];
    [[self webinfoProgressbar] startAnimation:self];
}

//- (void)webView:(WebView *)webView
//decidePolicyForNavigationAction:(NSDictionary *)actionInformation
//        request:(NSURLRequest *)request frame:(WebFrame *)frame
//decisionListener:(id < WebPolicyDecisionListener >)listener
//{
//    NSString *host = [[request URL] host];
//    if (host) {
//        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
//    } else {
//        [listener use];
//    }
//}

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    WebView *newWebView;
    if (activeWebView == [self webView] || activeWebView == [self exWebViewer]) {
        newWebView = [self exWebViewer];
        isInNewWin = YES;
        [NSApp beginSheet:[self exWebWindow] modalForWindow:[self mainWindow] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];

    }
    else if (activeWebView == [self infoWebView]) {
        newWebView = [self infoWebView];
//        isInNewWin = YES;
//        [NSApp beginSheet:[self exWebWindow] modalForWindow:[self mainWindow] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
        
    }

    
    return newWebView;
}


- (IBAction)closeExWebWindow:(id)sender
{
    [NSApp endSheet:[self exWebWindow]];
    [[self exWebWindow] orderOut:sender];
    //[self.exWebViewer.preferences setJavaScriptEnabled:YES];
}



- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.mainWindow makeKeyAndOrderFront:self];
    if (flag) {
        return NO;
    }
    return YES;
}

- (IBAction)connect:(id)sender {
    if ([mySharedData userName].length < 1) {
        [NSApp beginSheet:[self settingsSheet] modalForWindow:[self mainWindow] modalDelegate:self didEndSelector:NULL contextInfo:NULL];
    }
    else {
        [mySharedData getIPAddress];
        NSString *ip = [[NSString alloc]initWithFormat:@"%@:%@",NSLocalizedString(@"IP_Address", "IP Address"),[mySharedData ipAddress]];
        [[self ipAddressField]setStringValue:ip];

        [bussiness changeWebInfoView:[mySharedData userName] withPwd:[mySharedData userPwd] withMethod:0];
    }
}

- (IBAction)disConnect:(id)sender {
    [bussiness changeWebInfoView:[mySharedData userName] withPwd:[mySharedData userPwd] withMethod:2];
}

- (IBAction)viewInfo:(id)sender {
    [self.tabView selectTabViewItemAtIndex:1];
    [self showMainWin:nil];
}

- (IBAction)showMainWin:(id)sender {
    [[self mainWindow] makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)showWebInfo:(id)sender {
    [bussiness changeWebInfoView:[mySharedData userName] withPwd:[mySharedData userPwd] withMethod:3];
}
- (IBAction)exit:(id)sender {
    [NSApp terminate: nil];
}
@end
