//
//  Login.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "Login.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface Login ()<TencentSessionDelegate>
@property (nonatomic, strong, readwrite) TencentOAuth *oauth;
@property (nonatomic, copy, readwrite) LoginFinishBlock finishBlock;
@property (nonatomic, assign, readwrite) BOOL isLogin;
@end

@implementation Login
+ (instancetype)sharedLogin {       // 设计成单例
    static Login *login;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = [[Login alloc] init];
    });
    return login;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isLogin = NO;
        _oauth = [[TencentOAuth alloc] initWithAppId:@"222222" andDelegate:self];
    }
    return self;
}

- (BOOL)isLogin {
    return _isLogin;
}

- (void)loginWithFinishBlock:(LoginFinishBlock)finishBlock {

    _finishBlock = [finishBlock copy];

    [_oauth authorize:@[kOPEN_PERMISSION_GET_USER_INFO,
                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]];
    
//    _oauth.authMode = kAuthModeClientSideToken;
//    [_oauth authorize:@[kOPEN_PERMISSION_GET_USER_INFO,
//                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                        kOPEN_PERMISSION_ADD_ALBUM,
//                        kOPEN_PERMISSION_ADD_TOPIC,
//                        kOPEN_PERMISSION_CHECK_PAGE_FANS,
//                        kOPEN_PERMISSION_GET_INFO,
//                        kOPEN_PERMISSION_GET_OTHER_INFO,
//                        kOPEN_PERMISSION_LIST_ALBUM,
//                        kOPEN_PERMISSION_UPLOAD_PIC,
//                        kOPEN_PERMISSION_GET_VIP_INFO,
//                        kOPEN_PERMISSION_GET_VIP_RICH_INFO]];
}

- (void)logOut {
    [_oauth logout:self];
    _isLogin = NO;
}

#pragma mark - delegate

- (void)tencentDidLogin {
    _isLogin = YES;
    //保存openid
    [_oauth getUserInfo];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (_finishBlock) {
        _finishBlock(NO);
    }
}

- (void)tencentDidNotNetWork {
    NSLog(@"无网络连接，请设置网络");
}

- (void)tencentDidLogout {
    NSLog(@"登出成功");
}

// 登录成功后，QQ只返回一个OpenID，我们还需要通过OpenID去获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response {
    NSDictionary *userInfo = response.jsonResponse;
    _avatarUrl = userInfo[@"figureurl_qq_2"];
    _nick = userInfo[@"nickname"];
    _openid = _oauth.openId;
    if (_finishBlock) {
        _finishBlock(YES);
    }
}

@end
