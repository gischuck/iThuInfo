//
//  MainController.h
//  iThuInfo
//
//  Created by wenhao on 12-11-30.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base64Util.h"
#import "SharedObjects.h"
#import "MyBusiness.h"
#import <WebKit/WebKit.h>

@interface MainController : NSObject<NSApplicationDelegate, NSTabViewDelegate, NSWindowDelegate>
{
    NSStatusItem *_statusItem;
    SharedObjects *mySharedData;
    MyBusiness *bussiness;
    BOOL isInNewWin;
    WebView *activeWebView;
    
}

@property (unsafe_unretained) IBOutlet NSWindow *infoWindow;
@property (weak) IBOutlet WebView *infoWebView;

- (IBAction)connect:(id)sender;
- (IBAction)disConnect:(id)sender;
- (IBAction)viewInfo:(id)sender;
- (IBAction)showMainWin:(id)sender;
- (IBAction)showWebInfo:(id)sender;

@property (weak) IBOutlet NSTextField *currentUsages;
@property (weak) IBOutlet NSTextField *totalUsages;

@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSTextField *ipAddressField;
@property (weak) IBOutlet NSMenuItem *currentUsageMenuItem;
@property (unsafe_unretained) IBOutlet NSWindow *settingsSheet;
@property (weak) IBOutlet NSProgressIndicator *webinfoProgressbar;

@property (weak) IBOutlet NSProgressIndicator *exWinprogressIndicator;
@property (weak) IBOutlet NSProgressIndicator *mainWinprogressIndicator;
- (IBAction)exit:(id)sender;

@property (weak) IBOutlet NSWindow *mainWindow;
@property (weak) IBOutlet NSView *mainView;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSWindow *exWebWindow;
- (IBAction)closeExWebWindow:(id)sender;
@property (weak) IBOutlet WebView *exWebViewer;

@end
