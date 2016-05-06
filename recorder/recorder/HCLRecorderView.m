//
//  HCLRecorderView.m
//  recorder
//
//  Created by hcl on 16/5/6.
//  Copyright © 2016年 hclong. All rights reserved.
//

#import "HCLRecorderView.h"

@implementation HCLRecorderView
//-(instancetype)init{
//    
//    self = [super init];
////    滑动条和弹簧显示
//    self.showsHorizontalScrollIndicator = YES;
//    self.showsVerticalScrollIndicator = YES;
//     self.bounces = YES;
//    return self;
//}

//画图:
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.5);//线的宽度
    UIColor* aColor = [UIColor whiteColor];//白色
    
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
    int x = 0;
    for (NSNumber* number in self.array) {
        int y = [number intValue];
        y -= 20;
        CGPoint aPoints[2];//坐标点
        if(y<=1) y = 1;
        aPoints[0] =CGPointMake(x,self.frame.size.height/2- y*1.5);//坐标1
        aPoints[1] =CGPointMake(x, self.frame.size.height/2+y*1.5);//坐标2
        //CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
        //points[]坐标数组，和count大小
        CGContextAddLines(context, aPoints, 2);//添加线
        CGContextDrawPath(context, kCGPathStroke);
        x += 2;
    }
     CGPoint line[2];
    line[0]= CGPointMake(0, self.frame.size.height/2);
    line[1]= CGPointMake(self.frame.size.width, self.frame.size.height/2);
    CGContextAddLines(context, line, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke);
    //根据坐标绘制路径
    
    
    
}

@end
