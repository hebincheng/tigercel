//
//  ZYY_GetColorFromImage.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "ZYY_GetColorFromImage.h"
#define ScreeWidth ([[UIScreen mainScreen] bounds].size.width)

@interface ZYY_GetColorFromImage ()
{
    UIImageView *_moveImageView;
    NSArray *_colorArr;
}
@end

@implementation ZYY_GetColorFromImage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"选择颜色"];
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

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andImage:(UIImage *)image{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil)
    {
        self.imageBoard=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreeWidth, ScreeWidth)];
        //切圆形
//        [self.imageBoard.layer setCornerRadius:ScreeWidth/2.0f];
//        [self.imageBoard.layer setMasksToBounds:YES];
        [self.imageBoard setImage:[UIImage imageNamed:@"icon_color"]];
        [self.view addSubview:self.imageBoard];
        if (image!=nil)
        {
            [_imageBoard setImage:image];
        }
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch  locationInView:_imageBoard];
    _colorArr=[NSArray array];
    _colorArr=[_imageBoard colorOfPoint:point];
    UIColor *color=[UIColor colorWithRed:[_colorArr[0] floatValue]/255.0 green:[_colorArr[1] floatValue]/255.0 blue:[_colorArr[2] floatValue]/255.0 alpha:[_colorArr[3] floatValue]/255.0];
    [_colorBoard setBackgroundColor:color];
    if(point.y<ScreeWidth)
    {
        if (_moveImageView==nil) {
            _moveImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            [_moveImageView setImage:[UIImage imageNamed:@"icon_pickcolor"]];
            [self.view addSubview:_moveImageView];
        }
            [_moveImageView setCenter:CGPointMake(point.x+8, point.y+64)];
        }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
- (IBAction)saveBtn
{
    [_delegate setLedColorWithRed:[_colorArr[0] floatValue] Green:[_colorArr[1] floatValue] Blue:[_colorArr[2] floatValue]Alpha:[_colorArr[3] floatValue]];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
