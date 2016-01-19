//
//  ZYY_PickerDayView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYY_PickerDayViewDelegate<NSObject>

-(void)setAgainWeekWithArray:(NSArray *)array;

@end
@interface ZYY_PickerDayView : UIViewController
//确认触发事件
- (IBAction)sureBtn;

//代理属性
@property(nonatomic,weak)id<ZYY_PickerDayViewDelegate>delegate;

@end
