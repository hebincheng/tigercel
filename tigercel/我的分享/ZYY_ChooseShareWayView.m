//
//  ZYY_ChooseShareWayView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/19.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_ChooseShareWayView.h"
#import "ZYY_ShareMessageView.h"

#define RowHeight  60

@interface ZYY_ChooseShareWayView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //标题数组
    NSArray *_titleArr;
    //占位字符数组
    NSArray *_placeText;
}
@end

@implementation ZYY_ChooseShareWayView

- (void)viewDidLoad {
    [super viewDidLoad];
    MYLog(@"%@---%p",[self class],_LED);
    [self loadUI];
    // Do any additional setup after loading the view.
}
-(void)loadUI
{
    [self setTitle:@"分享方式"];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    
    _titleArr=@[@"用户ID分享",@"用户名分享",@"手机号分享",@"邮箱分享"];
    _placeText=@[@"请输入被分享人的用户ID",@"请输入被分享人的用户名",@"请输入被分享人的手机号",@"请输入被分享人的邮箱"];
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREE_WIDTH, RowHeight*_titleArr.count) style:UITableViewStylePlain];
    [_tableView setScrollEnabled:NO];
    [_tableView setAutoresizesSubviews:YES];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
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

#pragma mark -
#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    [cell.textLabel setText:_titleArr[indexPath.row]];
    //箭头样式
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYY_ShareMessageView *sharView=[[ZYY_ShareMessageView alloc]initWithNibName:@"ZYY_ShareMessageView" bundle:nil andPlaceText:_placeText[indexPath.row] andWay:indexPath.row];
    //将设置传给下一个界面
    sharView.LED=_LED;
    [self.navigationController pushViewController:sharView animated:YES];
}

@end
