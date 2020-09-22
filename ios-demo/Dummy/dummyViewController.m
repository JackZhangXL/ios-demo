//
//  dummyViewController.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "dummyViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface dummyViewController ()

@end

@implementation dummyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"width: %f", [[UIScreen mainScreen] bounds].size.width);
    NSLog(@"width: %f", [[UIScreen mainScreen] bounds].size.height);

    // 创建 JSVirtualMachine 对象 jsvm
    JSVirtualMachine *jsvm = [[JSVirtualMachine alloc] init];
    // 使用 jsvm 的 JSContext 对象 ct
    JSContext *ct = [[JSContext alloc] initWithVirtualMachine:jsvm];

    JSContext *context  = [[JSContext alloc] init];
    // 解析执行 JavaScript 脚本
    [context evaluateScript:@"var i = 4 + 8"];
    // 转换 i 变量为原生对象
    NSNumber *number = [context[@"i"] toNumber];
    NSLog(@"var i is %@, number is %@", context[@"i"], number);

    // 解析执行 JavaScript 脚本
    [context evaluateScript:@"function addition(x, y) { return x + y}"];
    // 获得 addition 函数
    JSValue *addition = context[@"addition"];
    // 传入参数执行 addition 函数
    JSValue *resultValue = [addition callWithArguments:@[@(4), @(8)]];
    // 将 addition 函数执行的结果转成原生 NSNumber 来使用。
    NSLog(@"function is %@; reslutValue is %@",addition, [resultValue toNumber]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
