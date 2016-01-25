//
//  ZYY_MyInformationView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYY_MyInformationView : UIViewController
- (IBAction)quit;
//ID的label
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
//姓名Label
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//设备Label
@property (weak, nonatomic) IBOutlet UILabel *equipmentNumLabel;
//电话label
@property (weak, nonatomic) IBOutlet UILabel *telNumberLabel;
//头像
@property (weak, nonatomic) IBOutlet UIButton *touXiang;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
- (IBAction)userImageBtn;

@end
