//
//  ZYY_SceneChooseView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_SceneChooseView.h"

#define ScreeWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreeHeight  ([[UIScreen mainScreen] bounds].size.height)

@interface ZYY_SceneChooseView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_imageArr;
    NSArray *_titleArr;
    NSArray *_controlArr;
}
@end

static NSString *cellID=@"cellID";

@implementation ZYY_SceneChooseView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _controlArr=@[@[@80,@20,@30],@[@70,@20,@60],@[@50,@50,@30],@[@56,@60,@10],@[@87,@20,@38],@[@15,@20,@83],@[@16,@20,@35],@[@80,@90,@80],@[@96,@20,@37],@[@16,@20,@36]];
    
    _titleArr=@[@"休闲",@"读书",@"节奏",@"柔和",@"动感",@"舞动",@"低调",@"狂欢",@"安静",@"音乐"];
    
    _imageArr=[NSMutableArray arrayWithCapacity:10];
    for (int i=1; i<=10; i++)
    {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"scenarios_%d",i]];
        [_imageArr addObject:image];
    }
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreeWidth, ScreeHeight) style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    //[_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark-
#pragma mark tableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.imageView setImage:_imageArr[indexPath.row]];
    [cell.detailTextLabel setText:_titleArr[indexPath.row]];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //[defaults setObject:_controlArr[indexPath.row] forKey:@"zhaoming"];
    //[defaults setObject:_titleArr[indexPath.row] forKey:@"sceneName"];
    [_delegate resetSceneNameWithName:_titleArr[indexPath.row] andSceneSetWithArr:_controlArr[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
