//
//  ZYY_UserReglationView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/11.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_UserReglationView.h"
#import "ZYY_GetInfoFromInternet.h"

@interface ZYY_UserReglationView ()
{
    NSString *_comment;
}
@end

@implementation ZYY_UserReglationView

- (void)viewDidLoad
{
    [super viewDidLoad];
    //请求使用条例的网络数据
    [[ZYY_GetInfoFromInternet instancedObj]getUserReglation:^(id data)
    {
        _comment=data;
        [self loadUI];
    }];
    [self.view setBackgroundColor:[UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0]];
    [self setTitle:@"使用条款"];
}
-(void)loadUI
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREE_WIDTH, SCREE_HEIGHT-64)];
    label.text=_comment;
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:18.0f]];
    [self.view addSubview:label];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
