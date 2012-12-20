//
//  MyBusiness.m
//  iThuInfo
//
//  Created by wenhao on 12-11-30.
//  Copyright (c) 2012年 wenhao. All rights reserved.
//

#import "MyBusiness.h"


@implementation MyBusiness

- (id) init
{
	if (self = [super init])
	{
        _method = -1;
        _userName = @"";
        _userPwd = @"";
        isLoginInfo = NO;
        isLoginWebInfo = NO;
        isLoginNet = NO;
		mySharedData = [SharedObjects sharedInstance];
        
	}
	return self;
}

- (void)login:(NSString *)userNameRef withPwd:(NSString *)userPwdRef withMethod:(NSInteger)method
{
    //判断是否已经登录
    NSURLRequest *requestTmp;
    if (method == 0) {
        requestTmp = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://net.tsinghua.edu.cn/"]
                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                       timeoutInterval:3];
    }
    else if(method == 1) {
        requestTmp = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.tsinghua.edu.cn/login.jsp"]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:3];
    }
    else if(method == 3) {
        requestTmp = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://portal.tsinghua.edu.cn"]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:3];
    }
    NSData *returnLatin = [NSURLConnection sendSynchronousRequest:requestTmp
                          returningResponse:nil
                                      error:nil];
    
    NSString *returnStringLatin = [[NSString alloc] initWithData:returnLatin encoding:NSISOLatin1StringEncoding];
    if (_method == 1 && ([returnStringLatin rangeOfString:@"https://m.tsinghua.edu.cn:443/Login"].length > 0))
    {
        isLoginInfo = NO;
    }
    else if(_method == 1)
    {
        isLoginInfo = YES;
        requestTmp = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.tsinghua.edu.cn/render.userLayoutRootNode.uP"]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:3];

        [[[mySharedData webView]mainFrame] loadRequest:requestTmp];
    }
    if (_method == 0 && ([returnStringLatin rangeOfString:@"/cgi-bin/do_login"].length > 0))
    {
        isLoginNet = NO;
    }
    else if(_method == 0)
    {
        isLoginNet = YES;
        NSString *returnString = [[NSString alloc] initWithData:returnLatin encoding:NSUTF8StringEncoding];
        NSLog(@"%@", returnString);
    }
    if (_method == 3 && ([returnStringLatin rangeOfString:@"portal.tsinghua.edu.cn:443/Login"].length > 0))
    {
        isLoginWebInfo = NO;
    }
    else if(_method == 3)
    {
        isLoginWebInfo = YES;
        requestTmp = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://http://portal.tsinghua.edu.cn/render.userLayoutRootNode.uP"]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:3];

        [[[mySharedData infoWebView]mainFrame] loadRequest:requestTmp];

    }
    //登录处理
    if (isLoginInfo == NO || isLoginNet == NO || isLoginWebInfo == NO)
    {
        //开始登录
        NSString *postString;
        if (_method == 0) {
            postString = [[NSString alloc]initWithFormat:@"username=%@&password=%@&drop=0&type=1&n=100",userNameRef, [MD5Encryption md5by32:userPwdRef]];
        }
        else if (_method == 1 || _method == 3) {
            postString = [[NSString alloc]initWithFormat:@"userName=%@&password=%@",userNameRef, userPwdRef];
        }
        
        //NSLog(@"%@",postString);
        //一般转化称UTF-8
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        if (_method == 0) {
            [request setURL:[NSURL URLWithString:@"http://net.tsinghua.edu.cn/cgi-bin/do_login"]];
        }
        else if (_method == 1) {
            [request setURL:[NSURL URLWithString:@"https://m.tsinghua.edu.cn/Login"]];
        }
        else if (_method == 3) {
            [request setURL:[NSURL URLWithString:@"https://portal.tsinghua.edu.cn:443/Login"]];
        }
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
        webData = [[NSMutableData alloc]init];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
    
}

//POST接收数据方法：
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // 错误处理
    NSLog(@"Error");
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *returnString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSString *returnStringLatin = [[NSString alloc] initWithData:webData encoding:NSISOLatin1StringEncoding];
    NSLog(@"connectionDidFinishLoading");
//    NSLog(@"%@",returnString);
//    NSLog(@"%@",returnStringLatin);
    
    if (_method == 0) {
        if ([returnString rangeOfString:@"error"].length > 0) {
            [[mySharedData statusItem]setImage:[NSImage imageNamed:@"stop"]];
            [mySharedData setNetworkStatus:NSLocalizedString(@"Connect_Error", @"Connect Error")];
            [mySharedData showMsgWin:[mySharedData networkStatus] withDetail:returnString inWin:[mySharedData mainWin]];
            [mySharedData setIsLoginNet:isLoginNet];
        }
        else{
            isLoginNet = YES;
            [mySharedData setIsLoginNet:isLoginNet];
            [[mySharedData statusItem]setImage:[NSImage imageNamed:@"play"]];
            [mySharedData setUsages:returnString];
            [[mySharedData totalUsages]setStringValue:[mySharedData getNetWorkUsage]];
            
            //启动线程
            checkJobs = [ThreadJobs ThreadInstance];
        }
        //[mySharedData setWebViewByData:returnString baseURL:@"http://net.tsinghua.edu.cn/"];
        
        NSLog(@"%@", returnString);
        
    }
    else if (_method == 1) {
        if ([returnStringLatin rangeOfString:@"top.window.location = '/login.jsp'"].length > 0) {
            [mySharedData showMsgWin:NSLocalizedString(@"Login_fail", @"Login fail") withDetail:NSLocalizedString(@"Login_fail_detail", @"Login fail detail") inWin:[mySharedData mainWin]];
        }
        else{
            [[[mySharedData webView]mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.tsinghua.edu.cn/render.userLayoutRootNode.uP"]]];
        }
        //[mySharedData setWebViewByData:returnString baseURL:@"http://m.tsinghua.edu.cn/"];
        
    }
    else if (_method == 3) {
        [[[mySharedData infoWebView]mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://portal.tsinghua.edu.cn/render.userLayoutRootNode.uP"]]];
        //[mySharedData setInfoWebViewByData:returnString baseURL:@"http://portal.tsinghua.edu.cn/"];
        [[mySharedData infoWindow] makeKeyAndOrderFront:NSApp];
    }

}

- (void)changeWebInfoView:(NSString *)userName withPwd:(NSString *)pwd withMethod:(NSInteger)method
{
    _userName = userName;
    _userPwd = pwd;
    _method = method;

    if (_method == 2) {
        webData = [[NSMutableData alloc]init];
        NSString *url = [NSString stringWithFormat:@"http://net.tsinghua.edu.cn/cgi-bin/do_logout"];
           
        NSString *returnString = [HttpHelper getHtml:url];
        [mySharedData setNetworkStatus:returnString];
        NSLog(@"%@",returnString);
        [[mySharedData statusItem]setImage:[NSImage imageNamed:@"stopplay"]];
        if ([returnString rangeOfString:@"error"].length > 0) {
            [mySharedData setNetworkStatus:returnString];
            [mySharedData showMsgWin:[mySharedData networkStatus] withDetail:returnString inWin:[mySharedData mainWin]];
        }
        else if ([returnString rangeOfString:@"ok"].length > 0){
            [mySharedData showMsgWin:NSLocalizedString(@"Disconnect", @"Disconnect") withDetail:NSLocalizedString(@"Disconnect_Success", @"Disconnect Success")  inWin:[mySharedData mainWin]];
            [[mySharedData currentUsages]setStringValue:@"Null"];
            [[mySharedData totalUsages]setStringValue:@"Null"];
        }
    }
    else
    {
        [self login:_userName withPwd:_userPwd withMethod:_method];
    }

}



@end
