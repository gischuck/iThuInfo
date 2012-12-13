//
//  UserData.m
//  iThuInfo
//
//  Created by wenhao on 12-11-30.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import "UserData.h"

@implementation UserData

- (id) init
{
	if (self = [super init])
	{
		mySharedData = [SharedObjects sharedInstance];
        
	}
	return self;
}

- (void)awakeFromNib
{
//    if ([mySharedData userName].length < 1) {
//        [NSApp beginSheet:userSheet modalForWindow:[mainController mainWindow] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
//        
//    }
}

-(IBAction)showUserSheet:(id)sender
{
    //mySharedData = [SharedObjects sharedInstance];
    
    
    if ([mySharedData userName].length > 0) {
        [username setStringValue:[mySharedData userName]];
    }
    if ([mySharedData userPwd].length > 0) {
        [userpwd setStringValue:[mySharedData userPwd]];
    }
    
    [NSApp beginSheet:userSheet modalForWindow:[mainController mainWindow] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
}

-(IBAction)endUserSheet:(id)sender
{
    NSString *encodepwd = [Base64Util encodeBase64:[userpwd stringValue]];
    NSArray *array = [[NSArray alloc]initWithObjects:[username stringValue],encodepwd, nil];
    //保存到文件
    [self saveData:array];
    //更新到sharedObjects
    [mySharedData setUserName:[username stringValue]];
    [mySharedData setUserPwd:[userpwd stringValue]];
    
    [NSApp endSheet:userSheet];
    [userSheet orderOut:sender];
}

- (void)saveData:(NSArray *)array
{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"iThuInfo/userInfo.cfg"];
    [NSKeyedArchiver archiveRootObject:array toFile:filename];
}

-(void)controlTextDidEndEditing:(NSNotification *)notification
{
    // See if it was due to a return
    if ( [[[notification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement )
    {
        [self endUserSheet:nil];
    }
}

@end
