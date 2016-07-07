//
//  JYJAccessTokenParam.h
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJAccessTokenParam : NSObject
/**	string	申请应用时分配的AppKey。*/
@property (nonatomic, copy) NSString *client_id;

/**	string	申请应用时分配的AppSecret。*/
@property (nonatomic, copy) NSString *client_secret;

/**	string	请求的类型，填写authorization_code */
@property (nonatomic, copy) NSString *grant_type;

/**	string	调用authorize获得的code值。*/
@property (nonatomic, copy) NSString *code;

/**	string	回调地址，需需与注册应用里的回调地址一致。*/
@property (nonatomic, copy) NSString *redirect_uri;
@end
