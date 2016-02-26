//
//  ZYY_MyInformationView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//  个人信息界面

#import "ZYY_MyInformationView.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "ZYY_ChangeCode.h"
#import "ZYY_User.h"
#import "ZYY_GetInfoFromInternet.h"
#import "UIButton+WebCache.h"
#import "ZYY_MQTTConnect.h"
#define RowHeight 50

@interface ZYY_MyInformationView ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_menuArr;
    NSMutableArray *_imageArr;
    NSMutableArray *_detailArr;
    //cell右侧的显示文本框
    UILabel *_contentLabel;
    //地址选择
    UIPickerView *_locationPickView;
    //地址字段
    NSString *_locationStr;
    //城市数组
    NSArray *_provinceArr;
    NSArray *_cityArr;
    NSArray *_townArr;
    NSDictionary *_locationDictionary;
    NSArray *_selectArr;
    //用户单例
    ZYY_User *_user;
    
    //创建一个Bool用于记录是否有信息改动
    BOOL sign;
}
@end

static NSString *cellID=@"cellID";

static NSString *pStr,*cStr,*tStr;

@implementation ZYY_MyInformationView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadUI];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(sign==YES)
    {
        NSString *sex=[_detailArr[0] isEqualToString:@"男"]?@"1":@"0";
        MYLog(@"保存的个人信息%@-%@-%@",_detailArr[1],sex,_detailArr[2]);
        NSString *adress=[_detailArr[2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *birthady=[_detailArr[1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[ZYY_GetInfoFromInternet instancedObj]commitUserInformationWithBirthdate:birthady andSex:sex andSessionId:_user.sessionId andAddress:adress andUserToken:_user.userToken];
    }
}

#pragma mark-
#pragma mark  加载数据及UI
-(void)loadData
{
    //初始化改动标识符为No
    sign=NO;
    //创建用户单例
    _user=[ZYY_User instancedObj];
    NSString *birthday=[_user.birthdate substringToIndex:10];
    //修改显示的时间格式
    NSString *yeatStr=[birthday substringToIndex:4];
    NSRange midRange={5,2};
    NSString *monStr=[birthday substringWithRange:midRange];
    NSString *dayStr=[birthday substringFromIndex:8];
    NSString *birStr=[NSString stringWithFormat:@"%@-%@-%@",yeatStr,monStr,dayStr];
    MYLog(@"%@",birStr);
    //初始化cell像是数组
    NSString *sex=[_user.sex isEqualToString:@"1"]?@"男":@"女";
    _detailArr=[NSMutableArray arrayWithObjects:sex,birStr,_user.address1,@"",_user.lastLoginDate,nil];
    MYLog(@"-------------%@",_user.address1);
    //标题内容
    if (_menuArr==nil)
    {
        _menuArr=@[@"性别",@"出生日期",@"家庭住址",@"修改密码",@"最近登录时间"];
    }
    //图像数组初始化
    _imageArr=[NSMutableArray arrayWithCapacity:5];
    for (int i=1; i<6; i++)
    {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"personal_%d",i]];
        [_imageArr addObject:image];
    }
    //地区选择器初始化
    _locationPickView=[[UIPickerView alloc]init];
    [_locationPickView setDataSource:self];
    [_locationPickView setDelegate:self];
    
    //省份数组初始化
    _locationDictionary=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    _provinceArr= [_locationDictionary allKeys];
    
    _selectArr =[_locationDictionary objectForKey: [_locationDictionary allKeys][0]];
    
    _cityArr= [_selectArr[0]  allKeys];
    _townArr =[_selectArr[0] objectForKey:_cityArr[0]];
    
    //城市的初始化
    pStr=_provinceArr[0];
    cStr=_cityArr[0];
    tStr=_townArr[0];
    _locationStr=[NSString stringWithFormat:@"%@-%@-%@",pStr,cStr,tStr];
}

-(void)loadUI
{
    //设置初始状态
    [_equipmentNumLabel setText:[NSString stringWithFormat:@"设备数量:%@",_user.userLevel]];
    [_nameLabel setText:_user.userName];
    [_telNumberLabel setText:_user.mobileNumber];
    [_emailLabel setText:_user.emailAddress1];
    [_IDLabel setText:[NSString stringWithFormat:@"ID:%@",_user.userId]];
    //设置头像为圆形、
   
    [_touXiang setBackgroundImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    if (![_user.titleMultiUrl isEqualToString:@""])
    {
        [_touXiang sd_setImageWithURL:[NSURL URLWithString:_user.titleMultiUrl] forState:UIControlStateNormal];
    }
    [_touXiang.layer setCornerRadius:50.0f];
    [_touXiang.layer setMasksToBounds:YES];
    //设置按钮点击效果
    [_touXiang setAdjustsImageWhenHighlighted:NO];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 180+60, SCREE_WIDTH, 5*RowHeight) style:UITableViewStylePlain];
    //[_tableView setAutoresizesSubviews:YES];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    [self setTitle:@"个人资料"];
}
#pragma mark-
#pragma mark pickerView协议代理方法
//picker行的数目
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0)
    {
        return _provinceArr.count;
    }
    else if(component==1)
    {
        return _cityArr.count;
    }
    else
        return _townArr.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
        return _provinceArr[row];
    }
    else if(component == 1)
    {
        return _cityArr[row];
    }
    else
        return _townArr[row];
        
}
//列的数目
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //为了使地区联动  而进行的数组关联
    if (component==0)
    {
        pStr=_provinceArr[row];
        _selectArr =[_locationDictionary objectForKey: pStr];
        //刷新第一列字段
        _cityArr= [_selectArr[0]  allKeys];
        [pickerView reloadComponent:1];
        //设置城市和区县的字段
        cStr=_cityArr[0];
        _townArr =[_selectArr[0] objectForKey:_cityArr[0]];
        //刷新第二列的字段
        [pickerView reloadComponent:2];
        tStr=[_selectArr[0] objectForKey:cStr][0];
    }
    if (component==1)
    {
        cStr=_cityArr[row];
        _townArr=[_selectArr[0] objectForKey:cStr];
        //设置区县的字段
        tStr=_townArr[0];
        [pickerView reloadComponent:2];
    }
    if (component==2)
    {
        tStr=_townArr[row];
    }
    _locationStr=[NSString stringWithFormat:@"%@-%@-%@",pStr,cStr,tStr];

}
//设置显示宽度代理方法
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 1)
    {
        return 100;
    }
    else
    {
        return 90;
    }
}


#pragma mark tableView协议代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell=[[UITableViewCell   alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    //设置箭头样式
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setText:_menuArr[indexPath.row]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [cell.imageView setImage: _imageArr[indexPath.row]];
#pragma mark  从网络获取数据后修改_detailArr的内容后 刷新表格
    
    [cell.detailTextLabel setText:_detailArr[indexPath.row]];
    MYLog(@"%@",_detailArr[indexPath.row]);
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0f]];
    
    //添加分割线
    if (indexPath.row<_menuArr.count)
    {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 55-10, self.view.bounds.size.width-20, 1)];
        [image setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
        [cell.contentView addSubview:image];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当用户进行信息修改选择的时候 将标识符变成YES
    sign=YES;
    
    if (indexPath.row==1)
    {
#pragma mark  日期选择器
        //初始化 dataPicker 日期选择
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        //设置为中国区
        [datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"]];
        datePicker.datePickerMode = UIDatePickerModeDate;
        //设置最大选择时间
        NSDate *date=[NSDate date];
        [datePicker setMaximumDate:date];
        
        //初始化UIAlertController
      
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:datePicker];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //实例化一个NSDateFormatter对象,用于把data转化成nsstring
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            //设定时间格式
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            //求出时间字符串
            NSString *dateString = [dateFormat stringFromDate:datePicker.date];
            dateString=[dateString substringToIndex:10];
            [_detailArr replaceObjectAtIndex:1 withObject:dateString];
            [_tableView reloadData];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self.navigationController presentViewController:alert animated:YES completion:^{ }];
    }
    if(indexPath.row==0)
    {
#pragma mark 性别选择器
         UIAlertController *alert= [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_detailArr replaceObjectAtIndex:0 withObject:@"男"];
            [_tableView reloadData];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_detailArr replaceObjectAtIndex:0 withObject:@"女"];
            [_tableView reloadData];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{ }];
    }
    if(indexPath.row==2)
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:_locationPickView];
        //通过自动布局来调整pickerview相对于alertView的位置
        [_locationPickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.equalTo(alert.view).offset(-10);
            make.leading.equalTo(alert.view.mas_leading).offset(-20);
        }];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //如果确定则将地址字段存储到用户文档中  然后刷新数据
            if(_locationStr!=nil)
            {
            [_detailArr replaceObjectAtIndex:2 withObject:_locationStr];
                [_tableView reloadData];
            }
        }];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (indexPath.row==3)
    {
        ZYY_ChangeCode *changeCodeView=[[ZYY_ChangeCode alloc]initWithNibName:@"ZYY_ChangeCode" bundle:nil];
        [self.navigationController pushViewController:changeCodeView animated:YES];
    }
}
#pragma mark imagePicker的代理方法--修改头像
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    __block UIImage *image=info[@"UIImagePickerControllerEditedImage"];

    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"APP-20160108-00000002160128134627.jpg"];
    NSData *data=UIImagePNGRepresentation(image);
    [data writeToFile: filePath atomically:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
#pragma mark 调用头像修改的接口
    [[ZYY_GetInfoFromInternet instancedObj]changeUserImageWithUserId:_user.userId andSessionId:_user.sessionId andImageStr:filePath block:^{
    
        //设置头像
        [_touXiang setImage:image forState:UIControlStateNormal];
        
        //修改成功后，获取用户信息  刷新头像链接
        [[ZYY_GetInfoFromInternet instancedObj]getUserInfoWithUserToken:_user.userToken andSessionId:_user.sessionId];
        //修改侧边栏的图片
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.leftView.imageBtn setImage:image forState:UIControlStateNormal];
    }] ;
}

#pragma mark  退出按钮
- (IBAction)quit
{
    [[ZYY_GetInfoFromInternet instancedObj]logoutSessionID:_user.sessionId andUserToken:_user.userToken and:^{
  //退出的时候断开连接 
         [[ZYY_MQTTConnect instancedObj]quit];
        
         [(AppDelegate *)[UIApplication sharedApplication].delegate showLoginView];
    }];
}
- (IBAction)userImageBtn {
    UIAlertController *touXiang=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerControl=[[UIImagePickerController alloc]init];
        [pickerControl setAllowsEditing:YES];
        [pickerControl setSourceType:UIImagePickerControllerSourceTypeCamera];
        [pickerControl setDelegate:self];
        [self presentViewController:pickerControl animated:YES completion:nil];
    }];
    UIAlertAction *library=[UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
        [pickerController setDelegate:self];
        [pickerController setAllowsEditing:YES];
        [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    [touXiang addAction:library];
    [touXiang addAction:camera];
    [touXiang addAction:cancel];
    
    [self.view.window.rootViewController presentViewController:touXiang animated:YES completion:nil];
}
@end
