//
//  ZYY_HomeTableViewCell.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYY_HomeTableViewCell : UITableViewCell
//图像视图
@property (weak, nonatomic) IBOutlet UIImageView *DeviceImageView;

//名字label
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//模式label
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
//开关选择

- (IBAction)chooseSwitch:(UISwitch *)sender;

@end
