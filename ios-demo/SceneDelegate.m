//
//  SceneDelegate.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "SceneDelegate.h"
#import "WKWebViewController.h"
#import "SizeViewController.h"
//#import "WXViewController.h"
#import "dummyViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

    // UIWindow 加载 UITabBarController，每个 tab 加载 UINavigationController。这样即使上面页面切换，也不影响底部tabBar，底部tabBar永远存在。
    UITabBarController *tabBarC = [[UITabBarController alloc] init];
    WKWebViewController *wkvc = [[WKWebViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:wkvc];

    SizeViewController *svc = [[SizeViewController alloc] init];
//    WXViewController *wxc = [[WXViewController alloc] init];
    dummyViewController *dvc = [[dummyViewController alloc] init];

    [tabBarC setViewControllers:@[nc, svc/*, wxc, dvc*/]];   // tab 位置是按这个顺序
    tabBarC.delegate = self;    // 实现delegate第二步：设置self为delegate的接收者

    [self.window setRootViewController:tabBarC];
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
