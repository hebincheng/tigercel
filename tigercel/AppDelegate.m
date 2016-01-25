//
//  AppDelegate.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYY_HomeViewController.h"
#import "ZYY_LeftViewController.h"
#import "ZYY_LoginControl.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //让其在启动页停留1.5秒
    [NSThread sleepForTimeInterval:1.5f];
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor blackColor]];
    [self.window makeKeyAndVisible];
    ZYY_LoginControl *loginView=[[ZYY_LoginControl alloc]initWithNibName:@"ZYY_LoginControl" bundle:nil];
    self.homeNavigationController=[[UINavigationController alloc]initWithRootViewController:loginView];
    //设置导航条颜色
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:167.0/255 green:220.0/255 blue:242.0/255 alpha:1.0] ];
//设置导航标题的颜色
//     self.homeNavigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1.0]};
    [self.window setRootViewController:self.homeNavigationController];
    
    //设置主页面
    ZYY_HomeViewController *homeVC=[[ZYY_HomeViewController alloc]init];
    self.homeNavigationController=[[UINavigationController alloc]initWithRootViewController:homeVC];
  
    //初始化左视图界面
    
    self.leftView=[[ZYY_LeftViewController alloc]init];
    self.LeftSlideVC=[[LeftSlideViewController alloc]initWithLeftView:_leftView andMainView:self.homeNavigationController];
    return YES;
}

-(void)showWindowHome
{
    self.homeNavigationController=nil;
    ZYY_LoginControl *loginView=[[ZYY_LoginControl alloc]initWithNibName:@"ZYY_LoginControl" bundle:nil];
    self.homeNavigationController=[[UINavigationController alloc]initWithRootViewController:loginView];
    [self.window setRootViewController:self.homeNavigationController];
    
//    self.leftView=[[ZYY_LeftViewController alloc]init];
//    ZYY_LoginControl *loginView=[[ZYY_LoginControl alloc]initWithNibName:@"ZYY_LoginControl" bundle:nil];
//    self.homeNavigationController = [[UINavigationController alloc] initWithRootViewController:loginView];
   
//   // self.window.rootViewController = self.homeNavigationController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
