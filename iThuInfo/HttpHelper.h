//
//  HttpHelper.h
//  iThuInfo
//
//  Created by wenhao on 12-12-2.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHelper : NSObject
+ (NSString *)getHtml: (NSString *)url;
+ (NSString *)getHtml: (NSString *)url Encoding:(NSStringEncoding)encoding;
+ (NSString *)getHtmlbyPost: (NSString *)url withPostData:(NSString *)postStr;
@end
