//
//  ZYY_ReBackView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYY_ReBackView : UIViewController
//提交内容
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
//字符数
@property (weak, nonatomic) IBOutlet UILabel *numberOfCharacterLabel;
//反馈标题
@property (weak, nonatomic) IBOutlet UITextField *titleOfContentText;
//提交触摸事件
- (IBAction)submitBtn;
@end
