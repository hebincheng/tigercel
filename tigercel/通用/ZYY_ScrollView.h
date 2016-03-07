//
//  ZYY_ScrollView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  建立分类来处理scrollView上的手势冲突事件

#import <UIKit/UIKit.h>

@protocol UIScrollViewControlDelegate <NSObject>

-(void)setCellEditing;

@end

@interface ZYY_ScrollView : UIScrollView

@property(nonatomic,weak) id<UIScrollViewControlDelegate> controlDelegate;

@end
