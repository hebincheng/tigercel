//
//  ZYY_LEDImageView.m
//  tigercel
//
//  Created by 虎符通信 on 16/3/2.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_LEDImageView.h"

@implementation ZYY_LEDImageView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame])
    {
        [self setImage:[UIImage imageNamed:@"lixian"]];
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.height, 30)];
        [self addSubview:_nameLabel];
    }
    return self;
}

@end
