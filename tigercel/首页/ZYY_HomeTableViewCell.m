//
//  ZYY_HomeTableViewCell.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_HomeTableViewCell.h"

@implementation ZYY_HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)chooseSwitch:(UISwitch *)sender
{
    NSLog(@"%d",sender.isOn);
}
@end
