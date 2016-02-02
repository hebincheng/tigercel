//
//  ZYY_ChangeNameView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  改变设备名字界面

#import <UIKit/UIKit.h>
@protocol ZYY_ChangeNameViewDelegate<NSObject>
-(void)resetProjectNameWithName:(NSString *)string;
@end

@interface ZYY_ChangeNameView : UIViewController

@property(weak,nonatomic)id<ZYY_ChangeNameViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *equipmentName;
//确认修改按钮
- (IBAction)changeBtn;

@end
