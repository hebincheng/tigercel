//
//  ZYY_AboutView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_AboutView.h"
#import "AppDelegate.h"
#import "ZYY_UserReglationView.h"
#import "ZYY_VersionExplainView.h"

#define HeightOfRow 55

@interface ZYY_AboutView ()<UITableViewDataSource,UITableViewDelegate>
{
    //菜单标题数组
    NSArray *_menuArr;
    //功能图像数组
    NSArray *_imageArr;
    
    UITableView *_tableView;
}
@end

@implementation ZYY_AboutView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}

#pragma mark-
#pragma mark- 加载UI
-(void)loadUI
{
    //[self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [self setTitle:@"关于"];
    _menuArr=@[@"版本更新",@"使用条例",@"版本申明"];
    UIImage *image1=[UIImage imageNamed:@"about_one"];
    UIImage *image2=[UIImage imageNamed:@"about_two"];
    UIImage *image3=[UIImage imageNamed:@"about_three"];
    _imageArr=@[image1,image2,image3];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64+150, [[UIScreen mainScreen] bounds].size.width, HeightOfRow*_menuArr.count)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [_tableView setAutoresizesSubviews:YES];
    [self.view addSubview:_tableView];
}
#pragma mark-
#pragma mark- 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    //添加分割线
    if (indexPath.row<_menuArr.count)
    {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 55-10, self.view.bounds.size.width-20, 1)];
        [image setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
        [cell.contentView addSubview:image];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:_menuArr[indexPath.row]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:44.0/255 green:44.0/255 blue:44.0/255 alpha:1.]];
    [cell.imageView setImage:_imageArr[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",_menuArr[indexPath.row]);
    if (indexPath.row==0)
    {
        //检测设备版本号与服务器版本号  如果不用更新
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的应用是最新版，无需更新" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }
    else if (indexPath.row==1)
    {
        ZYY_UserReglationView *userView=[[ZYY_UserReglationView alloc]init];
        [self.navigationController.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.navigationController pushViewController:userView animated:YES];
    }
    else if(indexPath.row==2)
    {
        ZYY_VersionExplainView *versionView=[[ZYY_VersionExplainView alloc]init];
        [self.navigationItem.backBarButtonItem setTitle:@"返回"];
        [self.navigationController pushViewController:versionView animated:YES];
    }
}

@end
