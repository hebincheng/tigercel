//
//  ZYY_SetTimeView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_SetTimeView.h"
#import "ZYY_SceneChooseView.h"
#import "ZYY_PickerDayView.h"

@interface ZYY_SetTimeView ()<UITableViewDataSource,UITableViewDelegate,ZYY_PickerDayViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    
    //起始时间
    NSString *_begainTime;
    //结束时间
    NSString *_overTime;
    //存储重复日期的数据
    NSMutableArray *_againWeek;
    //用于传值的定时数组
    NSArray *_timeArr;
    
}
@end

@implementation ZYY_SetTimeView

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr=@[@"选择场景",@"重复"];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [self.beganTime setBackgroundColor:[UIColor whiteColor]];
    [self.endTime setBackgroundColor:[UIColor whiteColor]];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 400, SCREE_WIDTH, 88) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
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
#pragma mark-
#pragma mark协议代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    [cell.textLabel setText:_titleArr[indexPath.row]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        ZYY_SceneChooseView *scence=[[ZYY_SceneChooseView alloc]init];
        [self.navigationController pushViewController:scence animated:YES];
    }
    else
    {
        ZYY_PickerDayView *pickWeek=[[ZYY_PickerDayView alloc]initWithNibName:@"ZYY_PickerDayView" bundle:nil];
        [pickWeek setDelegate:self];
        [self.navigationController pushViewController:pickWeek animated:YES];
    }
}


#pragma mark 代理方法的实现
-(void)setAgainWeekWithArray:(NSArray *)array
{
    //将下级页面的数组传过来
    _againWeek=[NSMutableArray arrayWithArray:array];
}

- (IBAction)saveBtn
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"ahh:mm"];
    _begainTime=[dateFormatter stringFromDate:_beganTime.date];
    _overTime=[dateFormatter stringFromDate:_endTime.date];
    if ([_beganTime.date compare:_endTime.date]==NSOrderedDescending)
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }
    else
    {
        if(_againWeek==nil)
        {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请设置重复日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
        }
        else
        {
            MYLog(@"%@-%@",_begainTime,_overTime);
            _timeArr=@[_begainTime,_overTime,_againWeek];
            BOOL sussece=[_delegate setRunTimeWithArray:_timeArr];
            if (sussece)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"与已有定时冲突，请修改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
            }
        }
    }
}
@end
