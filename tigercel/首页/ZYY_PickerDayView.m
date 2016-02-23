//
//  ZYY_PickerDayView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_PickerDayView.h"

@interface ZYY_PickerDayView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_btnArr;
    NSArray *_titleArr;
}
@end

@implementation ZYY_PickerDayView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"重复日期"];
    _btnArr=[NSMutableArray arrayWithCapacity:8];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    
    _titleArr=@[@"永不",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREE_WIDTH, 44*8) style:UITableViewStylePlain];
    [_tableView setAutoresizesSubviews:YES];
    [_tableView setScrollEnabled:NO];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    //自定义返回的按钮
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 15 , 15)];
    [back addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backBtn;
}
#pragma mark 添加返回用户按钮事件
-(void)tapBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(SCREE_WIDTH-30, 10, 20, 20)];
    [btn setSelected:NO];
    [btn setTag:indexPath.row+10];
    [btn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnArr addObject:btn];
    [cell.contentView addSubview:btn];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [btn setImage:[UIImage imageNamed:@"device_one"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"device_two"] forState:UIControlStateNormal];
    [cell.textLabel setText:_titleArr[indexPath.row]];
    return cell;
}

-(void)tapBtn:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.tag==10&&sender.selected==YES)
    {
        [_btnArr enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx!=0)
            {
                [obj setSelected:NO];
            }
        }];
    }
    else if(sender.tag!=10&&sender.selected==YES)
    {
    [_btnArr enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx==0&&obj.selected==YES)
        {
            obj.selected=NO;
        }
    }];
    }
}


- (IBAction)sureBtn
{
    NSMutableArray *arr=[NSMutableArray array];
   [_btnArr enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if (obj.selected==YES)
       {
           [arr addObject:_titleArr[idx]];
       }
   }];
    [_delegate setAgainWeekWithArray:arr];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
