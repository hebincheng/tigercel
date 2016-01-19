//
//  ZYY_SliderControl.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/13.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYY_SliderControl : UITableViewCell
//大图
@property (weak, nonatomic) IBOutlet UIButton *biggerBtn;
//小图
@property (weak, nonatomic) IBOutlet UIButton *smallerBtn;
//控制器滑竿
@property (weak, nonatomic) IBOutlet UISlider *controlSlider;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle;



//变大摸事件
- (IBAction)bigControlBtn;
//变小触摸事件
- (IBAction)smallControlBtn;
//滑竿控制事件
- (IBAction)controlSlider:(UISlider *)sender;

@end
