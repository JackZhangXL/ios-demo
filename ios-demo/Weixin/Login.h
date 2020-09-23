//
//  Login.h
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginFinishBlock)(BOOL isLogin);

@interface Login : NSObject
@property(nonatomic, strong, readonly)NSString *nick;
@property(nonatomic, strong, readonly)NSString *avatarUrl;
@property(nonatomic, strong, readonly)NSString *openid;

+ (instancetype)sharedLogin;

#pragma - mark - 登录

- (BOOL)isLogin;
- (void)loginWithFinishBlock:(LoginFinishBlock)finishBlock;
- (void)logOut;
@end

NS_ASSUME_NONNULL_END
