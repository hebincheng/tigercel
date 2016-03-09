//
//  ZYY_EquipmentDetailVie.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/12.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  设备操作界面

#import "ZYY_EquipmentDetailVie.h"
#import "ZYY_SliderControl.h"
#import "Masonry.h"
#import "ZYY_ChangeNameView.h"
#import "ZYY_SceneChooseView.h"
#import "ZYY_GetColorFromImage.h"
#import "ZYY_SetTimeView.h"
#import "ZYY_TimeTableViewCell.h"
#import "ZYY_ScrollView.h"
//用于将jsonStr转化成m2m
#import "iot_mod_lwm2m.h"
#import "iot_mod_lwm2m_json.h"

#import "MQTTClient.h"
#import "MQTTClientPersistence.h"

@interface ZYY_EquipmentDetailVie ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYY_ChangeNameViewDelegate,ZYY_SceneChooseViewDelegate,ZYY_SetTimeViewDelegate,ZYY_GetColorFromImageDelegate>
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
    NSString *_leftSceneName;
    NSArray *_leftSliderColorArr;
    NSArray *_leftSmallArr;
    NSArray *_leftBigArr;
    NSArray *_leftControlArr;
    
    NSArray *_functionArr;//第一组的内容
    
    NSString *_projectName;
    //右侧模式名字 右侧的滑竿值
    NSArray *_rightControlArr;
    NSString *_rightSceneName;
    
    
    NSUserDefaults *_userDefaults;
    //获取像素颜色的视图
    ZYY_GetColorFromImage *_colorFromImageView;
    
    //LED的属性
    ZYY_LED *_ledModel;
    //数组中的第几台设备
    NSInteger _num;
    BOOL sign;
    
    //定时数组
    NSMutableArray *_runTimeArr;
    
    //LED颜色
    UIColor *_color;
    NSArray *_colorChooseArr;
    
    //sliderArr
    NSMutableArray *_leftSliderArr;
    NSMutableArray *_rightSliderArr;
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
        _leftSceneName=led.currentSceneName;
        _leftControlArr=led.zhaoMingArr;
        _runTimeArr=[NSMutableArray arrayWithArray:led.timeArr];
        sign=YES;
    }
    return self;
}


-(void)loadData
{
    if (sign==NO)
    {
        sign=YES;
        _projectName=@"led";
        _leftSceneName=@"休闲";
        _leftControlArr=@[@80,@20,@30];
    }
    _functionArr=@[_projectName,@"照明模式",_leftSceneName];
    
    _rightSliderArr=[NSMutableArray array];
    _leftSliderArr=[NSMutableArray array];
    
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
    _colorChooseArr=[NSArray array];
    _color=[self getColorFromRow:0];
    
}


#pragma mark -
#pragma mark  加载UI
-(void)loadUI
{
    [self setTitle:@"设备详情"];
    _scrollView=[[ZYY_ScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREE_WIDTH,SCREE_HEIGHT)];
    //设置分页
    [_scrollView setPagingEnabled:YES];
    [_scrollView setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    //设置弹性效果
    [_scrollView setBounces:NO];
    //设置滚动条
    [_scrollView setShowsHorizontalScrollIndicator:YES];
    [_scrollView setShowsVerticalScrollIndicator:YES];
    //设置滚动区域
    [_scrollView setContentSize:CGSizeMake(SCREE_WIDTH*2, SCREE_HEIGHT-64)];
    [self.view addSubview:_scrollView];
    
    //设置左边tableView
    _leftTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, -1, SCREE_WIDTH, SCREE_HEIGHT-64) style:UITableViewStyleGrouped];
    _leftTableView.tag=100;
    [_leftTableView setDataSource:self];
    [_leftTableView setDelegate:self];
    [_leftTableView setBackgroundColor:[UIColor clearColor]];
    //注册nib
    [_leftTableView registerNib:[UINib nibWithNibName:@"ZYY_SliderControl" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:sliderCellID];
    [_scrollView addSubview:_leftTableView];
    //设置右边tableView
    _rightTableView =[[UITableView alloc]initWithFrame:CGRectMake(SCREE_WIDTH, -1, SCREE_WIDTH, SCREE_HEIGHT-64) style:UITableViewStyleGrouped];
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
    [leftBtn setFrame:CGRectMake(0, 0, 15, 15)];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
}


#pragma mark-
#pragma mark 协议方法
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    MYLog(@"asdasd");
    if(view==_leftTableView||view==_rightTableView)
        return NO;
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    MYLog(@"11");
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_runTimeArr removeObjectAtIndex:indexPath.row-1];
    [self reloadUI];
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
            [_leftSliderArr addObject:sliderCell];
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
                if (_leftSceneName!=nil&&indexPath.row==2)
                {
                    [cell.detailTextLabel setText:_leftSceneName];
                }
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
                [_rightSliderArr addObject:sliderCell];
                [sliderCell.menuTitle setText:_menuArr2[indexPath.row]];
                [sliderCell.smallerBtn setImage:_leftSmallArr[indexPath.row] forState:UIControlStateNormal];
                //设置滑竿的初始值
                [sliderCell.controlSlider setValue:[_rightControlArr[indexPath.row] floatValue]];
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
                //获取默认第一个颜色数组的颜色
                [cell.detailTextLabel setTextColor:_color];
                [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [cell.detailTextLabel setTextAlignment:NSTextAlignmentCenter];
                
                //来创建选择的3个触发按钮
                NSArray *titleArr=@[@"拍照",@"图片",@"圆环"];
                for (int i=0; i<3; i++)
                {
                    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(SCREE_WIDTH-80-80*i, 15, 60, 30)];
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
                    if(indexPath.row==2)
                    {
                        [cell.detailTextLabel setText:_rightSceneName];
                    }
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
            MYLog(@"%@",weekStr);
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark 右侧获取模式下的内容
-(UIColor *)getColorFromRow:(NSInteger )row{
  NSArray *fenWeiArr=[[NSUserDefaults standardUserDefaults] objectForKey:@"fenWeiSetArr"];
     NSArray *titleArr=[[NSUserDefaults standardUserDefaults] objectForKey:@"fenWeiTitleArr"];
    //照明模式名字
    _rightSceneName=titleArr[row];
    NSArray *setArr=fenWeiArr[row];//设置三个属性的数组
    NSArray *colorArr=setArr[0];//颜色数组是第一个元素
    _rightControlArr=@[@0,setArr[1],setArr[2]];
    CGFloat red= [colorArr[0] floatValue];
    CGFloat green= [colorArr[1] floatValue];
    CGFloat blue= [colorArr[2] floatValue];
    MYLog(@"%f-%f-%f",red,green,blue);
    _colorChooseArr=@[[NSNumber numberWithFloat:red] ,[NSNumber numberWithFloat:green],[NSNumber numberWithFloat:blue]];
    UIColor *color=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return color;
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
#pragma mark-
#pragma mark场景模式
-(void)controlTheEquipmentWithMode:(NSInteger )mode
{
    if (mode==1)
    {
        NSArray *zhaoMingArr=[self getZhaoMingSet];
        MYLog(@"%@",zhaoMingArr);
    }
    else{
        NSArray *fenWeiArr=[self getFenWeiSet];
        MYLog(@"%@",fenWeiArr);
    }
}


-(NSArray *)getZhaoMingSet
{
    NSMutableArray *mArr=[NSMutableArray array];
    //由于loadUI和willappear加载了两次
    for (ZYY_SliderControl *sliderControl in _leftSliderArr)
    {
        int val=(int)sliderControl.controlSlider.value;
        [mArr addObject:[NSNumber numberWithInt:val]];
    }
    return mArr;
}




-(void)saveZhaoMingScene
{
    MYLog(@"成功新增照明场景");

   NSArray *arr= [[NSUserDefaults standardUserDefaults]objectForKey:@"zhaoMingSetArr"];
    NSMutableArray *saveArr=[NSMutableArray arrayWithArray:arr];
    NSArray *mArr=[self getZhaoMingSet];
    [saveArr addObject:mArr];
    [_leftSliderArr removeAllObjects];
    MYLog(@"saveArr-%@",saveArr);
    //新增照明模式
    [[NSUserDefaults standardUserDefaults] setObject: saveArr forKey:@"zhaoMingSetArr"];
}
-(NSArray *)getFenWeiSet{
    
    NSMutableArray *mArr=[NSMutableArray array];
    //首先添加颜色的rgb
    [mArr addObject:_colorChooseArr];
    for (ZYY_SliderControl *sliderControl in _rightSliderArr)
    {
        int val=(int)sliderControl.controlSlider.value;
        [mArr addObject:[NSNumber numberWithInt:val]];
    }
    return mArr;

}


-(void)saveFenWeiScene
{
    MYLog(@"成功新增氛围场景");
    NSArray *arr= [[NSUserDefaults standardUserDefaults]objectForKey:@"fenWeiSetArr"];
    MYLog(@"arr-%@",arr);
    NSMutableArray *saveArr=[NSMutableArray arrayWithArray:arr];
    NSArray *mArr=[self getFenWeiSet];
    [saveArr addObject:mArr];
    [_rightSliderArr removeAllObjects];
    MYLog(@"saverArr-%@",saveArr);
    //新增照明模式
    [[NSUserDefaults standardUserDefaults] setObject: saveArr forKey:@"fenWeiSetArr"];
}
#pragma mark 实现修改界面的代理方法
-(void)setLedColorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha
{
    _colorChooseArr=@[[NSNumber numberWithFloat:red] ,[NSNumber numberWithFloat:green],[NSNumber numberWithFloat:blue]];
    _color=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
        [self reloadUI];
}
//设置定时数组  刷新数据
-(BOOL)setRunTimeWithArray:(NSArray *)array
{
    __block BOOL enAble=YES;
    for (NSArray *arr in _runTimeArr)
    {
        for (NSString *week in arr[2])//先判断重复的日期  如果没有相同则直接进入下一段循环
        {
            for (NSString *newWeek in array[2])//对比两者中有没有相同的星期数
            {
                if ([newWeek isEqualToString:week])
                {
                    MYLog(@"--------------");
                    //检测闹钟是否冲突  
                    BOOL enable=[self textClockTimeWithTimeArr:arr andAnOtherTimeArr:array];
                    if (enable==YES)//说明闹钟有冲突
                    {
                        return NO;
                    }
                    else
                    {
                        [_runTimeArr addObject:array];
                        [self reloadUI];
                        return YES;
                    }
                }
            }
        }
    }
    [_runTimeArr addObject:array];
    [self reloadUI];
    return enAble;
}
#pragma mark  检测时钟是否冲突
-(BOOL)textClockTimeWithTimeArr:(NSArray *)firstArr andAnOtherTimeArr:(NSArray *)secondArr
{
    NSString *firstStartTime=[NSString stringWithFormat:@"%@",firstArr[0]];
    NSString *firsrEndTime=firstArr[1];
    NSString *seconedStartTime=[NSString stringWithFormat:@"%@",secondArr[0]];
    NSString *seconedEndTime=secondArr[1];
    MYLog(@"%@---%@",firstStartTime,firsrEndTime);
    MYLog(@"%@---%@",seconedStartTime,seconedEndTime);
    if ([seconedStartTime compare:firsrEndTime]==NSOrderedDescending)
    {
        MYLog(@"开始时间比已有定时终止时间早");
        return NO;
    }
    if ([seconedEndTime compare:firstStartTime]==NSOrderedAscending)
    {
        MYLog(@"结束时间比已有定时起始时间早");
        return NO;
    }
    MYLog(@"%ld",[firstStartTime compare:seconedStartTime]);
 
    return YES;
}


-(void)reloadUI{
    [_leftSliderArr removeAllObjects];
    [_rightSliderArr removeAllObjects];
    [_leftTableView reloadData];
    [_rightTableView reloadData];
}



-(void)resetZhaoMingSceneNameWithName:(NSString *)name andSceneSetWithArr:(NSArray *)array
{
    _leftSceneName=name;
    _leftControlArr=array;
    [self reloadUI];
    //_functionArr=@[_projectName,@"照明模式",_sceneName];
    MYLog(@"%@-%@",_projectName,_leftSceneName);
}

-(void)resetFenWeiSceneNameWithName:(NSString *)name andSceneSetWithArr:(NSArray *)array{
    _rightSceneName=name;
    NSArray *colorArr=array[0];//颜色数组是第一个元素
    _rightControlArr=@[@0,array[1],array[2]];
    CGFloat red= [colorArr[0] floatValue];
    CGFloat green= [colorArr[1] floatValue];
    CGFloat blue= [colorArr[2] floatValue];
    MYLog(@"%f-%f-%f",red,green,blue);
    _color=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    [self reloadUI];
}

-(void)resetProjectNameWithName:(NSString *)string{
    _projectName=string;
    
     _functionArr=@[_projectName,@"照明模式",@"a"];
    [self reloadUI];
}

#pragma mark cell的行选择方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYLog(@"%ld---%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section==0)
    {
        //修改名称
        if (indexPath.row==0)
        {
            ZYY_ChangeNameView *changeNameView=[[ZYY_ChangeNameView alloc]initWithNibName:@"ZYY_ChangeNameView" bundle:nil];
            [changeNameView setDelegate:self];
            [self.navigationController pushViewController:changeNameView animated:YES];
        }
        else if(indexPath.row==2&&tableView==_leftTableView)
        {
            ZYY_SceneChooseView *sceneChooseView=[[ZYY_SceneChooseView alloc]initWithSelect:0];
            [sceneChooseView setDelegate:self];
            [self.navigationController pushViewController:sceneChooseView animated:YES];
        }
        else if(indexPath.row==2&&tableView==_rightTableView)
        {
            ZYY_SceneChooseView *sceneChooseView=[[ZYY_SceneChooseView alloc]initWithSelect:1];
            [sceneChooseView setDelegate:self];
            [self.navigationController pushViewController:sceneChooseView animated:YES];
        }
    }
}
#pragma mark imagePicker设置代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   UIImage *image=info[@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:picker completion:^{
        _colorFromImageView=[[ZYY_GetColorFromImage alloc]initWithNibName:@"ZYY_GetColorFromImage" bundle:nil andImage:image];
        [_colorFromImageView setDelegate:self];
        [self.navigationController pushViewController:_colorFromImageView animated:YES];
    }];
    
}



#pragma mark-
#pragma mark 点击事件
-(void)tapBack
{
#pragma mark 返回时保存设备参数
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"led.data"];
    MYLog(@"----%ld",_num);
    if (_num==0)
    {
        _ledModel=[[ZYY_LED alloc]init];
        _ledModel.deviceName=_projectName;
        _ledModel.currentSceneName=_leftSceneName;
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
        MYLog(@"%ld",_num);
        _ledModel=[[ZYY_LED alloc]init];
        _ledModel.deviceName=_projectName;
        _ledModel.currentSceneName=_leftSceneName;
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
    [_delegate reLoadTableView];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)tapColorBtn:(UIButton *)sender
{
    MYLog(@"%ld",(long)sender.tag);
    if (sender.tag==1002)
    {
        _colorFromImageView=[[ZYY_GetColorFromImage alloc]initWithNibName:@"ZYY_GetColorFromImage" bundle:nil andImage:nil];
        [_colorFromImageView setDelegate:self];
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
    MYLog(@"%d",sender.isOn);
}

-(void)tapAddBtn
{
    ZYY_SetTimeView *set=[[ZYY_SetTimeView alloc]initWithNibName:@"ZYY_SetTimeView" bundle:nil];
    [set setDelegate:self];
    [self.navigationController pushViewController:set animated:YES];
    MYLog(@"添加定时");
}
#pragma mark  设备操作
-(BOOL)controlEquipmentWithJsonString:(NSString *)jsonString
{
    char *sendData=(char*)[jsonString UTF8String];//将NSString转化成char*格式

    int len;
    iot_mod_json_lwm2m_header_t send_header, receive_header,header_test;
    
    memset(&send_header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    memset(&receive_header, 0, sizeof(iot_mod_json_lwm2m_header_t));
    memset(&header_test, 0, sizeof(iot_mod_json_lwm2m_header_t));
    
    len = iot_mod_json_to_lwm2m(sendData, &send_header);//将json格式转化成m2m格式
    unsigned char myPayload[2048];
    
    memcpy(myPayload, &send_header.operation, 2);
    memcpy(myPayload+2, &send_header.sequence, 2);
    memcpy(myPayload+4, &send_header.objId, 2);
    memcpy(myPayload+6, &send_header.retCode, 2);
    memcpy(myPayload+8, send_header.body, len);
    
    for (int i=0; i<len+8; i++)
    {
        MYLog(@"%02x",*(myPayload+i));
    }
    return YES;
}

@end
