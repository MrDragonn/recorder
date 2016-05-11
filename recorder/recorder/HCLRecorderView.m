//
//  HCLRecorderView.m
//  recorder
//
//  Created by hcl on 16/5/6.
//  Copyright © 2016年 hclong. All rights reserved.
//

#import "HCLRecorderView.h"

@implementation HCLRecorderView


//画图:
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);//线的宽度
    UIColor* aColor = [UIColor whiteColor];//白色
    
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
    float x = 0;
    for (NSNumber* number in self.array) {
        float y = [number intValue];
        y  = y+30;
        if(y<=1) y = 0.1;
       
        CGPoint aPoints[2];//坐标点
        if(y<=1) y = 1;
        aPoints[0] =CGPointMake(x,(self.frame.size.height-30)/2- self.frame.size.height*y*1.5/160);//坐标1+25
        aPoints[1] =CGPointMake(x, (self.frame.size.height-30)/2+self.frame.size.height*y*1.5/160);//坐标2-25
        //CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
        //points[]坐标数组，和count大小
        CGContextAddLines(context, aPoints, 2);//添加线
        
        if (IS_IPHONE_6) {
            x += 375.0/250.0;
        }
        if (IS_IPHONE_6P) {
            x+= 414.0/250.0;
        }
        if (IS_IPHONE_5) {
            x+=320.0 /250.0;
        }
    }
     CGPoint line[2];
    line[0]= CGPointMake(0, (self.frame.size.height-30)/2);
    line[1]= CGPointMake(self.frame.size.width, (self.frame.size.height-30)/2);
    CGContextAddLines(context, line, 2);//添加线
    //根据坐标绘制路径
   CGContextDrawPath(context, kCGPathStroke);
    
     CGContextRef context2 = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context2, 1);//线的宽度
    CGContextSetStrokeColorWithColor(context2, aColor.CGColor);//线框颜色
    CGPoint lline[2];
    lline[0]= CGPointMake(0, 30);
    lline[1]= CGPointMake(self.frame.size.width, 30);
    CGContextAddLines(context2, lline, 2);//添加线
    CGContextDrawPath(context2, kCGPathStroke);
}

@end
