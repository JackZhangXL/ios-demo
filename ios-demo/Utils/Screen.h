//
//  Screen.h
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 是否为横屏的宏
#define IS_LANDSCAPE (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

// 根据横屏竖屏取屏幕宽高
#define SCREEN_WIDTH (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

// 根据屏幕尺寸进行缩放
static inline NSInteger UIAdapter (float x){
    CGFloat scale = 414 / SCREEN_WIDTH; // 因为视觉稿是 iphone6P 是 414 宽度
    return (NSInteger)x /scale;
}

static inline CGRect UIRectAdapter(x, y, width, height){
    return CGRectMake(UIAdapter(x), UIAdapter(y), UIAdapter(width), UIAdapter(height));
}

// 暴露给外部调用
#define UI(x) UIAdapter(x)
#define UIRect(x,y,width,height) UIRectAdapter(x,y,width,height)

// 是否是 iphoneX / XR / XMAX
#define IS_IPHONE_X (SCREEN_WIDTH == [Screen sizeFor58Inch].width && SCREEN_HEIGHT == [Screen sizeFor58Inch].height)
#define IS_IPHONE_XR (SCREEN_WIDTH == [Screen sizeFor61Inch].width && SCREEN_HEIGHT == [Screen sizeFor61Inch].height && [UIScreen mainScreen].scale == 2)
#define IS_IPHONE_XMAX (SCREEN_WIDTH == [Screen sizeFor65Inch].width && SCREEN_HEIGHT == [Screen sizeFor65Inch].height && [UIScreen mainScreen].scale == 3)

// 这三种机型有留海屏
#define IS_IPHONE_X_XR_MAX (IS_IPHONE_X || IS_IPHONE_XR || IS_IPHONE_XMAX)
//
//// 如果是留海屏，调整 statusBar 高度
#define STATUSBAR_HEIGHT (IS_IPHONE_X_XR_MAX ? 44 : 20)

@interface Screen : NSObject
+ (CGSize)sizeFor58Inch;    // iphonex
+ (CGSize)sizeFor61Inch;    // iphone xr
+ (CGSize)sizeFor65Inch;    // iphone xs max
@end

NS_ASSUME_NONNULL_END
