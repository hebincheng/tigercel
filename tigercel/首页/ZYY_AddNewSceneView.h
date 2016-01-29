//
//  ZYY_AddNewSceneView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/29.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
//设置代理方法  在设备管理界面保存数据
@protocol ZYY_AddNewSceneViewDelegate<NSObject>

-(void)saveZhaoMingScene;
-(void)saveFenWeiScene;

@end

@interface ZYY_AddNewSceneView : UIViewController


@property(weak,nonatomic)id<ZYY_AddNewSceneViewDelegate>delegate;
//保存按钮
- (IBAction)saveBtn;
//保存的场景名字
@property (weak, nonatomic) IBOutlet UITextField *sceneName;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSelected:(NSInteger)selecte;
@end
