//
//  ZYY_MyInformationView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/10.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYY_MyInformationView : UIViewController
- (IBAction)quit;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipmentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *telNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end
