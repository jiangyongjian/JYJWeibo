//
//  JYJOAuthViewController.m
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJOAuthViewController.h"
#import "MBProgressHUD+MJ.h"

#import "JYJControllerTool.h"
#import "JYJAccountTool.h"
#import "JYJAccount.h"

@interface JYJOAuthViewController () <UIWebViewDelegate>

@end

@implementation JYJOAuthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建UIWebView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    // 加载登录页面
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=4058339239&redirect_uri=http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    
    // 设置代理
    webView.delegate = self;
}


#pragma mark - UIWebViewDelegate
/**
 *  UIWebView开始加载资源的时候调用(开始发送请求)
 */
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中..."];
}

/**
 *  UIWebView加载完毕的时候调用(请求完毕)
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

/**
 *  UIWebView加载失败的时候调用(请求失败)
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

/**
 *  UIWebView每当发送一个请求之前，都会先调用这个代理方法（询问代理允不允许加载这个请求）
 *
 *  @param request        即将发送的请求
 
 *  @return YES : 允许加载， NO : 禁止加载
 */

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.获得请求地址
    NSString *url = request.URL.absoluteString;
    // 2.判断url是否为回调地址
    NSString *str = [NSString stringWithFormat:@"%@/?code=",JYJRedirectURI];
    NSRange range = [url rangeOfString:str];
    if (range.location != NSNotFound) { // 是回调地址
        // 截取授权成功后的请求标记
        
        int from = range.length + range.location;
        NSString *code = [url substringFromIndex:from];
        
        // 根据code获得一个accessToken
        [self accessTokenWithCode:code];
        
        // 禁止加载页面
        return NO;
    }
    
    return YES;
}

/**
 *  根据code获得一个accessToken
 *
 *  @return code 授权成功后的请求标记
 */

- (void)accessTokenWithCode:(NSString *)code
{
//    
//    client_id	true	string	申请应用时分配的AppKey。
//    client_secret	true	string	申请应用时分配的AppSecret。
//    grant_type	true	string	请求的类型，填写authorization_code
//    
//    grant_type为authorization_code时
// 	必选	类型及范围	说明
//    code	true	string	调用authorize获得的code值。
//    redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
    // 1.封装请求参数
    JYJAccessTokenParam *param = [[JYJAccessTokenParam alloc] init];
    param.client_id = JYJAppKey;
    param.client_secret = JYJAppSecret;
    param.redirect_uri = JYJRedirectURI;
    param.grant_type = @"authorization_code";
    param.code = code;
    
    // 2.获得accessToken
    [JYJAccountTool accesTokenWithParam:param success:^(JYJAccount *account) {
        // 隐藏HUD
        [MBProgressHUD hideHUD];

        // 存储账号模型
        [JYJAccountTool save:account];

        // 切换控制器（可能去新特性|tabBar）
        [JYJControllerTool chooseRootViewController];
    } failure:^(NSError *error) {
        // 隐藏HUD
        [MBProgressHUD hideHUD];
        JYJLog(@"请求失败---%@", error);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
