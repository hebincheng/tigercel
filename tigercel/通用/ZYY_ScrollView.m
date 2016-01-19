//
//  ZYY_ScrollView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_ScrollView.h"
#import "ZYY_TimeTableViewCell.h"

@implementation ZYY_ScrollView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    if ([result.superview isKindOfClass:[ZYY_TimeTableViewCell class]])
    {
        self.scrollEnabled =NO;
        [self.controlDelegate setCellEditing];
    }
    else
    {
        self.scrollEnabled = YES;
    }
    //[super hitTest:point withEvent:event];
    return result;
}


@end
