//
//  HttpHelper.m
//  iThuInfo
//
//  Created by wenhao on 12-12-2.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper
+ (NSString *)getHtml: (NSString *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:5.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
 
    // 发送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil
                                                           error:nil];
    
    return [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
}

+ (NSString *)getHtml: (NSString *)url Encoding:(NSStringEncoding)encoding
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:5.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    
    // 发送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil
                                                           error:nil];
    
    return [[NSString alloc] initWithData:returnData encoding:encoding];
}

+ (NSString *)getHtmlbyPost: (NSString *)url withPostData:(NSString *)postStr
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // 发送同步请求, 这里得returnData就是返回得数据了
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:5.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    //得到提交数据的长度
    NSString* len = [NSString stringWithFormat:@"%ld", [postData length]];
    //添加一个http包头告诉服务器数据长度是多少
    [request setValue:len forHTTPHeaderField:@"Content-Length"];
    //初始化Data
    
    // 发送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil
                                                           error:nil];
    
    return [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
}
@end
