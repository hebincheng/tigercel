//
//  UIImageView+ZYY_GetColor.m
//  tigercel
//
//  Created by 虎符通信 on 16/1/14.
//  Copyright © 2016年 虎符通信. All rights reserved.
//

#import "UIImageView+ZYY_GetColor.h"

@implementation UIImageView (ZYY_GetColor)

- (NSArray *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    NSString *red=[NSString stringWithFormat:@"%d",pixel[0]];
    NSString *green=[NSString stringWithFormat:@"%d",pixel[1]];
    NSString *blue=[NSString stringWithFormat:@"%d",pixel[2]];
    NSString *apha=[NSString stringWithFormat:@"%d",pixel[3]];
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);

   // UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    NSArray *colorArr=@[red,green,blue,apha];
    return colorArr;
}

@end
