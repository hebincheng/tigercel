//
//  ZYY_SceneChooseView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_SceneChooseView.h"
#import "ZYY_AddNewSceneView.h"

@interface ZYY_SceneChooseView ()<UITableViewDataSource,UITableViewDelegate,ZYY_AddNewSceneViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_imageArr;
    
    NSMutableArray *_titleArr;
    NSMutableArray *_setArr;
    
    //选择的模式  照明/氛围
    NSInteger _selectSign;

}
@end

static NSString *cellID=@"cellID";

@implementation ZYY_SceneChooseView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
   
}
-(void)loadUI{
    [self setTitle:@"场景选择"];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];

    if (_selectSign ==0)
    {
        _setArr=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"zhaoMingSetArr"]];
        _titleArr=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"zhaoMingtitleArr"]];
        MYLog(@"%@",_setArr);
        MYLog(@"%@",_titleArr);
    }
    else
    {
        MYLog(@"123");
        _setArr=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"fenWeiSetArr"]];
        _titleArr=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"fenWeiTitleArr"]];
        MYLog(@"%@",_titleArr);
    }
//    _controlArr=@[@[@80,@20,@30],@[@70,@20,@60],@[@50,@50,@30],@[@56,@60,@10],@[@87,@20,@38],@[@15,@20,@83],@[@16,@20,@35],@[@80,@90,@80],@[@96,@20,@37],@[@16,@20,@36]];
//    
//    _titleArr=@[@"休闲",@"读书",@"节奏",@"柔和",@"动感",@"舞动",@"低调",@"狂欢",@"安静",@"音乐"];
    
    _imageArr=[NSMutableArray arrayWithCapacity:10];
    for (int i=1; i<=10; i++)
    {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"scenarios_%d",i]];
        [_imageArr addObject:image];
    }
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREE_WIDTH, SCREE_HEIGHT) style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    //[_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];
    //添加新增场景的button
    UIButton *right=[UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(0, 0, 20 , 20)];
    [right addTarget:self action:@selector(addNewScene) forControlEvents:UIControlEventTouchUpInside];
    [right setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:right];
    
    [self.navigationItem setRightBarButtonItem:rightBtn];
    // Do any additional setup after loading the view from its nib.
    
    //自定义返回的按钮
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 15 , 15)];
    [back addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backBtn;
}



-(void)saveFenWeiScene
{
    [_delegate saveFenWeiScene];
}

-(void)saveZhaoMingScene
{
    [_delegate saveZhaoMingScene];
}

-(id)initWithSelect:(NSInteger )selectSign{
    self=[super init];
    if (self!=nil)
    {
        _selectSign=selectSign;
    }
    return self;
}
#pragma mark 添加返回用户按钮事件
-(void)tapBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 添加场景
-(void)addNewScene
{
    ZYY_AddNewSceneView *addNew=[[ZYY_AddNewSceneView alloc]initWithNibName:@"ZYY_AddNewSceneView" bundle:nil andSelected:_selectSign];
    [addNew setDelegate:self];
    [self.navigationController pushViewController:addNew animated:YES];
}

#pragma mark-
#pragma mark tableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _setArr.count;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    MYLog(@"123");
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    if (_titleArr.count==1)
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请至少保留1个场景" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }
    else
    {
        [_titleArr removeObjectAtIndex:indexPath.row];
        MYLog(@"%@",_setArr);
        [_setArr removeObjectAtIndex:indexPath.row];
        if (_selectSign==0)
        {
            [def setObject:_titleArr forKey:@"zhaoMingtitleArr"];
            [def setObject:_setArr forKey:@"zhaoMingSetArr"];
        }
        else if (_selectSign==1)
        {
            [def setObject:_titleArr forKey:@"fenWeiTitleArr"];
            [def setObject:_setArr forKey:@"fenWeiSetArr"];
        }
    }
    [_tableView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.imageView setImage:_imageArr[arc4random_uniform(10)]];
    [cell.detailTextLabel setText:_titleArr[indexPath.row]];
    MYLog(@"%ld",indexPath.row);
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectSign==0)//照明模式的场景选择
    {
        [_delegate resetZhaoMingSceneNameWithName:_titleArr[indexPath.row] andSceneSetWithArr:_setArr[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(_selectSign==1)//氛围模式
    {
        [_delegate resetFenWeiSceneNameWithName:_titleArr[indexPath.row] andSceneSetWithArr:_setArr[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
