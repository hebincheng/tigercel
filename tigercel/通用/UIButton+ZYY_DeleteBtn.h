//
//  UIButton+ZYY_DeleteBtn.h
//  tigercel
//
//  Created by 虎符通信 on 16/3/7.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  建立button的分类来调整按钮的响应范围

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (ZYY_DeleteBtn)

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
