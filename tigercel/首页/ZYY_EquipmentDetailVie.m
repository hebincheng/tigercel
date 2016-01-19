//
//  ZYY_EquipmentDetailVie.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/12.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_EquipmentDetailVie.h"
#import "ZYY_SliderControl.h"
#import "Masonry.h"
#import "ZYY_ChangeNameView.h"
#import "ZYY_SceneChooseView.h"
#import "ZYY_GetColorFromImage.h"
#import "ZYY_SetTimeView.h"
#import "ZYY_TimeTableViewCell.h"
#import "ZYY_ScrollView.h"

#define ScreeWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreeHeight  ([[UIScreen mainScreen] bounds].size.height)

@interface ZYY_EquipmentDetailVie ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYY_ChangeNameViewDelegate,ZYY_SceneChooseViewDelegate,ZYY_SetTimeViewDelegate>
{
    ZYY_ScrollView *_scrollView;
    //左tableVIew
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    //三组菜单名称数组
    NSArray *_menuArr1;
    NSArray *_menuArr2;
    NSArray *_menuArr3;
    
    //左侧tableView 第二组的UI内容  包括 滑竿颜色，左按钮图，右按钮图数组
    NSArray *_leftSliderColorArr;
    NSArray *_leftSmallArr;
    NSArray *_leftBigArr;
    NSArray *_leftControlArr;
    
    NSArray *_functionArr;//第一组的内容
    
    NSString *_projectName;
    NSString *_sceneName;
    NSUserDefaults *_userDefaults;
    //获取像素颜色的视图
    ZYY_GetColorFromImage *_colorFromImageView;
    
    //LED的属性
    ZYY_LED *_ledModel;
    NSInteger _num;
    BOOL sign;
    
    //定时数组
    NSMutableArray *_runTimeArr;
}
@end

static NSString *leftCellID=@"leftCellID";
static NSString *sliderCellID=@"sliderCellID";
static NSString *rightCellID=@"rightCellID";

@implementation ZYY_EquipmentDetailVie

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadUI];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLEDInformation:(ZYY_LED *)led andNumber:(NSInteger)number
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil)
    {
        _ledModel=[[ZYY_LED alloc]init];
        _ledModel=led;
        _num=number;
        _projectName=led.deviceName;
        _sceneName=led.currentSceneName;
        _leftControlArr=led.zhaoMingArr;
        _runTimeArr=[NSMutableArray arrayWithArray:led.timeArr];
        sign=YES;
    }
    return self;
}

//页面出现的时候设置数据
-(void)viewWillAppear:(BOOL)animated{
    if (sign==NO)
    {
        sign=YES;
        _projectName=@"led";
        _sceneName=@"休闲";
        _leftControlArr=@[@80,@20,@30];
    }
    _functionArr=@[_projectName,@"照明模式",_sceneName];
    [_leftTableView reloadData];
    [_rightTableView reloadData];
}

-(void)loadData
{
    if (_runTimeArr==nil)
    {
        _runTimeArr=[NSMutableArray array];
    }
    
    _userDefaults=[NSUserDefaults standardUserDefaults];
    #pragma mark 项目名字  场景
    _menuArr1=@[@"名称",@"当前模式",@"应用场景"];
    _menuArr2=@[@"亮度",@"色温",@"呼吸速度"];
    _menuArr3=@[@"灯光颜色",@"亮度",@"呼吸速度"];
    _leftSliderColorArr=@[[UIColor blueColor],[UIColor orangeColor],[UIColor redColor]];
    _leftBigArr=@[[UIImage imageNamed:@"highicon"],[UIImage imageNamed:@"temhigh"],[UIImage imageNamed:@"spehigh"]];
    _leftSmallArr=@[[UIImage imageNamed:@"lowicon"],[UIImage imageNamed:@"temlow"],[UIImage imageNamed:@"spelow"]];
}


#pragma mark -
#pragma mark  加载UI
-(void)loadUI
{
    [self setTitle:@"设备详情"];
    _scrollView=[[ZYY_ScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreeWidth,ScreeHeight)];
    //设置分页
    [_scrollView setPagingEnabled:YES];
    [_scrollView setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    //设置弹性效果
    [_scrollView setBounces:NO];
    //设置滚动条
    [_scrollView setShowsHorizontalScrollIndicator:YES];
    [_scrollView setShowsVerticalScrollIndicator:YES];
    //设置滚动区域
    [_scrollView setContentSize:CGSizeMake(ScreeWidth*2, ScreeHeight-64)];
    [self.view addSubview:_scrollView];
    
    //设置左边tableView
    _leftTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, -1, ScreeWidth, ScreeHeight) style:UITableViewStyleGrouped];
    _leftTableView.tag=100;
    [_leftTableView setDataSource:self];
    [_leftTableView setDelegate:self];
    [_leftTableView setBackgroundColor:[UIColor clearColor]];
    //注册nib
    [_leftTableView registerNib:[UINib nibWithNibName:@"ZYY_SliderControl" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:sliderCellID];
    [_scrollView addSubview:_leftTableView];
    //设置右边tableView
    _rightTableView =[[UITableView alloc]initWithFrame:CGRectMake(ScreeWidth, -1, ScreeWidth, ScreeHeight) style:UITableViewStyleGrouped];
    _rightTableView.tag=200;
    [_rightTableView setDelegate:self];
    [_rightTableView setDataSource:self];
    [_rightTableView setBackgroundColor:[UIColor clearColor]];
    [_rightTableView registerNib:[UINib nibWithNibName:@"ZYY_SliderControl" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:sliderCellID];
    [_scrollView addSubview:_rightTableView];
   //自定义返回按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
   // [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(tapBack) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
}


#pragma mark-
#pragma mark 协议方法
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    NSLog(@"asdasd");
    if(view==_leftTableView||view==_rightTableView)
        return NO;
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"11");
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_runTimeArr removeObjectAtIndex:indexPath.row-1];
    [_rightTableView reloadData];
    [_leftTableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3&&indexPath.row!=0)
    {
        return YES;
    }
    return NO;
}

#pragma mark cell单元的内容 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    if (tableView.tag==100)
    {
        if(indexPath.section==1)
        {
            ZYY_SliderControl *sliderCell=[tableView dequeueReusableCellWithIdentifier: sliderCellID forIndexPath:indexPath];
            [sliderCell.menuTitle setText:_menuArr2[indexPath.row]];
            //设置 滑竿的变大图片，变小图片，滑竿的颜色，滑竿的值
            [sliderCell.smallerBtn setImage:_leftSmallArr[indexPath.row] forState:UIControlStateNormal];
            [sliderCell.biggerBtn setImage:_leftBigArr[indexPath.row] forState:UIControlStateNormal];
            [sliderCell.controlSlider setMinimumTrackTintColor:_leftSliderColorArr[indexPath.row]];
            //判断是否为初始状态。
            if (_leftControlArr!=nil)
            {
                 [sliderCell.controlSlider setValue:[_leftControlArr[indexPath.row] floatValue]];
            }
            
            [sliderCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return sliderCell;
        }
        else
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
            if (indexPath.section==0)
            {
                if (indexPath.row!=1)
                {
                    
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                }
                [cell.detailTextLabel setText:_functionArr[indexPath.row]];
                [cell.detailTextLabel setTextColor:[UIColor blackColor]];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0f]];
                [cell.textLabel setText:_menuArr1[indexPath.row]];
            }
            else if(indexPath.section==2)
            {
                [cell.textLabel setText:@"省电模式"];
                UISwitch *modeSwitch=[[UISwitch alloc]init];
                [cell.contentView addSubview:modeSwitch];
                [modeSwitch addTarget:self action:@selector(tapModeSwitch:) forControlEvents:UIControlEventValueChanged];
                [modeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.equalTo(cell.contentView.mas_trailing).offset(-20);
                    make.centerY.equalTo(cell.textLabel);
                }];
            }
            [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        }
    }
    //---------------------以下为右边tableView的设置-------------------//
    else
    {
        if (indexPath.section==1)
        {
            if (indexPath.row!=0)
            {
                
                ZYY_SliderControl *sliderCell=[tableView dequeueReusableCellWithIdentifier: sliderCellID forIndexPath:indexPath];
                [sliderCell.menuTitle setText:_menuArr2[indexPath.row]];
                [sliderCell.smallerBtn setImage:_leftSmallArr[indexPath.row] forState:UIControlStateNormal];
                [sliderCell.controlSlider setValue:[_leftControlArr[indexPath.row] floatValue]];
                [sliderCell.biggerBtn setImage:_leftBigArr[indexPath.row] forState:UIControlStateNormal];
                [sliderCell.controlSlider setMinimumTrackTintColor:_leftSliderColorArr[indexPath.row]];
                
                [sliderCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return sliderCell;
            }
            else
            {
                //选色的设置
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
                [cell.textLabel setText:@"灯光颜色"];
                [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
                [cell.detailTextLabel setText:@"LED"];
                [cell.detailTextLabel setTextColor:[UIColor blackColor]];
                [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [cell.detailTextLabel setTextAlignment:NSTextAlignmentCenter];
                
                //来创建选择的3个触发按钮
                NSArray *titleArr=@[@"拍照",@"图片",@"圆环"];
                for (int i=0; i<3; i++)
                {
                    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(ScreeWidth-80-80*i, 15, 60, 30)];
                    [btn setTitle:titleArr[i] forState:UIControlStateNormal];
                    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
                    [btn setTag:i+1000];
                    [btn addTarget:self action:@selector(tapColorBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:btn];
                }
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
        else
        {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                //第一部分的设置
                if (indexPath.section==0)
                {
                    [cell.detailTextLabel setText:_functionArr[indexPath.row]];
                    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
                    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0f]];
                    [cell.textLabel setText:_menuArr1[indexPath.row]];
                    if (indexPath.row!=1)
                    {
                        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    }
                    else
                    {
                        [cell.detailTextLabel setText:@"氛围模式"];
                    }
                }
                //第三部分的设置
                else if(indexPath.section==2)
                {
                    [cell.textLabel setText:@"省电模式"];
                    UISwitch *modeSwitch=[[UISwitch alloc]init];
                    [cell.contentView addSubview:modeSwitch];
                    [modeSwitch addTarget:self action:@selector(tapModeSwitch:) forControlEvents:UIControlEventValueChanged];
                    [modeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.trailing.equalTo(cell.contentView.mas_trailing).offset(-20);
                        make.centerY.equalTo(cell.textLabel);
                    }];
                }
                [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            }
        }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //------------------------------公共部分设置-----------------------------
    if(indexPath.section==3)
    {
        if (indexPath.row==0)
        {
            [cell.textLabel setText:@"定时"];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"添加" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBounds:CGRectMake(0, 0, 80, 40)];
            [btn addTarget:self action:@selector(tapAddBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.textLabel);
                make.trailing.equalTo(cell.contentView.mas_trailing).offset(-20);
            }];
            
            UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setTitle:@"编辑" forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"icon_jian"] forState:UIControlStateNormal];
            [btn1.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn1 setBounds:CGRectMake(0, 0, 80, 40)];
            [btn1 addTarget:self action:@selector(tapDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.textLabel);
                make.trailing.equalTo(cell.contentView.mas_trailing).offset(-100);
            }];
        }
        else
        {
            cell=[[ZYY_TimeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"123456"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSArray *arr=_runTimeArr[indexPath.row-1];
            NSString *str=[NSString stringWithFormat:@"%@-%@",arr[0],arr[1]];
            [cell.textLabel setText:str];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
            NSString *weekStr=[NSString string];
            for (NSString *obj in arr[2])
            {
                weekStr=[weekStr stringByAppendingPathComponent:obj];
            }
            [cell.detailTextLabel setText:weekStr];
            NSLog(@"%@",weekStr);
            UISwitch *modeSwitch=[[UISwitch alloc]init];
            [cell.contentView addSubview:modeSwitch];
            [modeSwitch setOn:YES];
            [modeSwitch addTarget:self action:@selector(tapModeSwitch:) forControlEvents:UIControlEventValueChanged];
            [modeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(cell.contentView.mas_trailing).offset(-20);
                make.centerY.equalTo(cell.textLabel);
            }];
            
            return cell;
        }
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 60;
}


//选择每个分组的cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0||section==1)
    {
        return 3;
    }
    else if(section==2)
    {
        return 1;
    }
    else
        return _runTimeArr.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark 实现修改界面的代理方法
-(void)setRunTimeWithArray:(NSArray *)array
{
    NSLog(@"1");
    [_runTimeArr addObject:array];
}

-(void)resetSceneNameWithName:(NSString *)name andSceneSetWithArr:(NSArray *)array
{
    _sceneName=name;
    _leftControlArr=array;
    //_functionArr=@[_projectName,@"照明模式",_sceneName];
    NSLog(@"%@-%@",_projectName,_sceneName);}

-(void)resetProjectNameWithName:(NSString *)string{
   // _functionArr=@[_projectName,@"照明模式",_sceneName];
    _projectName=string;
}

#pragma mark cell的行选择方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld---%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section==0)
    {
        //修改名称
        if (indexPath.row==0)
        {
            ZYY_ChangeNameView *changeNameView=[[ZYY_ChangeNameView alloc]initWithNibName:@"ZYY_ChangeNameView" bundle:nil];
            [changeNameView setDelegate:self];
            [self.navigationController pushViewController:changeNameView animated:YES];
        }
        else if(indexPath.row==2)
        {
            ZYY_SceneChooseView *sceneChooseView=[[ZYY_SceneChooseView alloc]init];
            [sceneChooseView setDelegate:self];
            [self.navigationController pushViewController:sceneChooseView animated:YES];
        }
    }
}
#pragma mark 设置代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   UIImage *image=info[@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:picker completion:^{
        _colorFromImageView=[[ZYY_GetColorFromImage alloc]initWithNibName:@"ZYY_GetColorFromImage" bundle:nil andImage:image];
        [self.navigationController pushViewController:_colorFromImageView animated:YES];
    }];
    
}



#pragma mark-
#pragma mark 点击事件
-(void)tapBack
{
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"led.data"];
    NSLog(@"----%ld",_num);
    if (_num==0)
    {
        _ledModel=[[ZYY_LED alloc]init];
        _ledModel.deviceName=_projectName;
        _ledModel.currentSceneName=_sceneName;
        _ledModel.zhaoMingArr=_leftControlArr;
        _ledModel.timeArr=_runTimeArr;
        NSMutableArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr==nil)
        {
            arr=[NSMutableArray array];
        }
        [arr addObject:_ledModel];
        [NSKeyedArchiver archiveRootObject:arr toFile:filePath];
    }
    else {
        NSLog(@"%ld",_num);
        _ledModel=[[ZYY_LED alloc]init];
        _ledModel.deviceName=_projectName;
        _ledModel.currentSceneName=_sceneName;
        _ledModel.zhaoMingArr=_leftControlArr;
        _ledModel.timeArr=_runTimeArr;
        NSMutableArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr==nil)
        {
            arr=[NSMutableArray array];
        }
        [arr replaceObjectAtIndex:_num-1 withObject:_ledModel];
        [NSKeyedArchiver archiveRootObject:arr toFile:filePath];
        
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)tapColorBtn:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag==1002)
    {
        _colorFromImageView=[[ZYY_GetColorFromImage alloc]initWithNibName:@"ZYY_GetColorFromImage" bundle:nil andImage:nil];
        [self.navigationController pushViewController:_colorFromImageView animated:YES];
    }
    else if(sender.tag==1001)
    {
        //图像选择器  需遵循其两个代理方法
        UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
        [pickerController setDelegate:self];
        [pickerController setAllowsEditing:YES];
        [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:pickerController animated:YES completion:nil];
    }
    else if (sender.tag==1000)
    {
        //图像选择器  需遵循其两个代理方法
        UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
        [pickerController setDelegate:self];
        [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [pickerController setAllowsEditing:YES];
        [self presentViewController:pickerController animated:YES completion:nil];
    }
}
-(void)tapDeleteBtn:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected==YES)
    {
        [_leftTableView setEditing:YES animated:YES];
        [_rightTableView setEditing:YES animated:YES];
    }
    else{
        [_leftTableView setEditing:NO animated:YES];
        [_rightTableView setEditing:NO animated:YES];
    }
}

-(void)tapModeSwitch:(UISwitch *)sender
{
    NSLog(@"%d",sender.isOn);
}

-(void)tapAddBtn
{
    ZYY_SetTimeView *set=[[ZYY_SetTimeView alloc]initWithNibName:@"ZYY_SetTimeView" bundle:nil];
    [set setDelegate:self];
    [self.navigationController pushViewController:set animated:YES];
    NSLog(@"添加定时");
}
@end
