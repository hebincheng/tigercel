//
//  ZYY_SetTimeView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYY_SetTimeViewDelegate <NSObject>

-(BOOL)setRunTimeWithArray:(NSArray *)array;

@end


@interface ZYY_SetTimeView : UIViewController
@property id<ZYY_SetTimeViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker *beganTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTime;
- (IBAction)saveBtn;

@end
