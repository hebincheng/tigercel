//
//  ZYY_LeftViewController.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/8.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义代理用于在home界面push出界面 ，后由于另外更好的方法 ，暂不用，保留以作后续准备
@protocol ZYY_LeftViewControllerDelegate<NSObject>

-(void)pushViewController:(UIViewController *)viewController;

@end

@interface ZYY_LeftViewController : UIViewController

@property(nonatomic,strong)UITableView *tableView;
//设置代理属性
@property(nonatomic,weak)id<ZYY_LeftViewControllerDelegate> delegate;

@end
