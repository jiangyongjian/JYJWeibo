//
//  JYJSendStatusParam.h
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJBaseParam.h"

@interface JYJSendStatusParam : JYJBaseParam
/**	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
@property (nonatomic, copy) NSString *status;
@end
