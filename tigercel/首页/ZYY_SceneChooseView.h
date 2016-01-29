//
//  ZYY_SceneChooseView.h
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYY_SceneChooseViewDelegate<NSObject>

-(void)resetZhaoMingSceneNameWithName:(NSString *)name andSceneSetWithArr:(NSArray *)array;
-(void)resetFenWeiSceneNameWithName:(NSString *)name andSceneSetWithArr:(NSArray *)array;
-(void)saveZhaoMingScene;

-(void)saveFenWeiScene;

@end

@interface ZYY_SceneChooseView : UIViewController

-(id)initWithSelect:(NSInteger )selectSign;

@property(weak,nonatomic)id<ZYY_SceneChooseViewDelegate>delegate;

@end
