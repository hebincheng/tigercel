//
//  ZYY_SliderControl.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/13.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_SliderControl.h"

@implementation ZYY_SliderControl

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bigControlBtn {
    _controlSlider.value++;
}

- (IBAction)smallControlBtn {
    _controlSlider.value--;
    NSLog(@"%f",_controlSlider.value);
}

- (IBAction)controlSlider:(UISlider *)sender {
    NSLog(@"---%d",(int)sender.value);
}
@end
