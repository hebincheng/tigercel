//
//  UIImageView+ZYY_GetColor.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  自定义UIImageView 来获取view某点的颜色

#import <UIKit/UIKit.h>

@interface UIImageView (ZYY_GetColor)

- (NSArray *) colorOfPoint:(CGPoint)point;

@end
