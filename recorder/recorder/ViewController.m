//
//  ViewController.m
//  recorder
//
//  Created by hcl on 16/5/6.
//  Copyright © 2016年 hclong. All rights reserved.
//

#import "ViewController.h"
#import "HCLRecorderController.h"
@interface ViewController ()

@property(nonatomic,strong) UIButton * recordBtn;


@end

@implementation ViewController
-(UIButton *)recordBtn{
    if (!_recordBtn) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 200, 300, 200)];
        [btn setTitle:@"开启录音机" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor grayColor];
        _recordBtn = btn;
    }
    return _recordBtn;
}




- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.recordBtn];
  
    [self.recordBtn addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
// 点击录音机按钮
-(void)recordClick:(UIButton *)sender{
    HCLRecorderController * hcl =[[HCLRecorderController alloc]init];
    [self presentViewController:hcl animated:YES completion:nil];
    
    }
@end
