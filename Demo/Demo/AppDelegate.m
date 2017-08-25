//
//  AppDelegate.m
//  Demo
//
//  Created by 冯倩 on 2017/8/25.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "AppDelegate.h"
#import "FQWelcomeController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    FQWelcomeController *vc = [[FQWelcomeController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

//根据不同的状态跳转界面
- (void)resetRootViewController
{
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
}


@end
