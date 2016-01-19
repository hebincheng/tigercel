//
//  AppDelegate.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "ZYY_LeftViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic)ZYY_LeftViewController *leftView;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *homeNavigationController;

-(void)showWindowHome;

@end

