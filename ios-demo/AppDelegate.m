//
//  AppDelegate.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "AppDelegate.h"
#import "WKWebViewController.h"
#import "SizeViewController.h"
#import "WXViewController.h"
//#import "dummyViewController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>   // 实现delegate第一步：声明要实现的delegate

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // UIWindow 加载 UITabBarController，每个 tab 加载 UINavigationController。这样即使上面页面切换，也不影响底部tabBar，底部tabBar永远存在。
    UITabBarController *tabBarC = [[UITabBarController alloc] init];
    WKWebViewController *wkvc = [[WKWebViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:wkvc];
    
    SizeViewController *svc = [[SizeViewController alloc] init];
    WXViewController *wxvc = [[WXViewController alloc] init];
//    dummyViewController *dvc = [[dummyViewController alloc] init];

    [tabBarC setViewControllers:@[nc, svc, wxvc/*, dvc*/]];   // tab 位置是按这个顺序
    tabBarC.delegate = self;    // 实现delegate第二步：设置self为delegate的接收者

    [self.window setRootViewController:tabBarC];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
