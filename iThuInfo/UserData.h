//
//  UserData.h
//  iThuInfo
//
//  Created by wenhao on 12-11-30.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainController.h"
#import "Base64Util.h"
#import "SharedObjects.h"

@interface UserData : NSObject<NSTextFieldDelegate>
{
    IBOutlet MainController *mainController;
    IBOutlet NSWindow *userSheet;
    //Data
    IBOutlet NSTextField *username;
    IBOutlet NSSecureTextField *userpwd;
    
    SharedObjects *mySharedData;
}

-(IBAction)showUserSheet:(id)sender;
-(IBAction)endUserSheet:(id)sender;


@end
