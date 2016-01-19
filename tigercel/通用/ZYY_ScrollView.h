//
//  ZYY_ScrollView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIScrollViewControlDelegate <NSObject>

-(void)setCellEditing;

@end

@interface ZYY_ScrollView : UIScrollView

@property(nonatomic,weak) id<UIScrollViewControlDelegate> controlDelegate;

@end
