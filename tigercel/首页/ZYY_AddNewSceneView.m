//
//  ZYY_AddNewSceneView.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/29.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_AddNewSceneView.h"

@interface ZYY_AddNewSceneView ()
{
    NSInteger _selectMode;//照明，氛围
}
@end

@implementation ZYY_AddNewSceneView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"保存新场景"];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0]];
    
    //自定义返回的按钮
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 15 , 15)];
    [back addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    //[back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=backBtn;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 添加返回用户按钮事件
-(void)tapBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtn {
    MYLog(@"asd");
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if (_selectMode==0)
    {
        NSArray *arr=[def objectForKey:@"zhaoMingtitleArr"];
        if (arr.count==10)
        {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"最多支持自定义10个场景模式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
        }
        else{
            NSMutableArray *mArr=[NSMutableArray arrayWithArray:arr];
            [mArr addObject:_sceneName.text];
            [def setObject:mArr forKey:@"zhaoMingtitleArr"];
            [_delegate saveZhaoMingScene];
        }
    }
    else if (_selectMode==1)
    {
        NSArray *arr=[def objectForKey:@"fenWeiTitleArr"];
        if (arr.count==10)
        {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"提示" message:@"最多支持自定义10个场景模式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
        }
        else
        {
            NSMutableArray *mArr=[NSMutableArray arrayWithArray:arr];
            [mArr addObject:_sceneName.text];
            [def setObject:mArr forKey:@"fenWeiTitleArr"];
            [_delegate saveFenWeiScene];
        }
    }
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSelected:(NSInteger)selecte
{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _selectMode=selecte;
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
