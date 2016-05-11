//
//  ViewController.m
//  recorder
//
//  Created by hcl on 16/5/6.
//  Copyright © 2016年 hclong. All rights reserved.
//

#import "HCLRecorderController.h"
#import <AVFoundation/AVFoundation.h>
#import "HCLRecorderView.h"
@interface HCLRecorderController ()<AVAudioRecorderDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）
@property (nonatomic,strong) NSTimer *timer2;
@property(nonatomic,strong) UIButton * recordBtn;
@property(nonatomic,strong) UIButton * pauseBtn;
@property(nonatomic,strong) UIButton * resumeBtn;
@property(nonatomic,strong) UIButton * stopeBtn;
@property(nonatomic,copy)NSMutableArray * array;
@property(nonatomic,strong)HCLRecorderView * voiceView;
@property(nonatomic,strong)UIScrollView * scrollView;
//保存声音地址数组
@property(nonatomic,copy)NSMutableArray * voiceArray;

@end

@implementation HCLRecorderController
#pragma 声波视图
-(NSMutableArray *)voiceArray{
    if (!_voiceArray) {
        _voiceArray = [NSMutableArray array];
    }
    return _voiceArray;
    
    
    
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 20, self.view.frame.size.width, 300);
        _scrollView.backgroundColor = [UIColor lightGrayColor];
     
    }
    return _scrollView;
    
    
}
//声波视图
#pragma  mark number2;
-(HCLRecorderView *)voiceView{
    if (!_voiceView) {
        _voiceView = [[HCLRecorderView alloc]init];
        _voiceView.frame =CGRectMake(0, 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        
        _voiceView.backgroundColor = [UIColor blackColor];
        //添加数字
        
        for (int i = 0 ; i <=5; i++) {
          UILabel * label =[UILabel new];
            
            label.frame= CGRectMake(i*self.view.frame.size.width/5+20, 10, 30, 10);
            label.textColor = [UIColor  whiteColor];
            label.text = [NSString stringWithFormat:@"%d%d:%d%d",i/600%6,i/60%10,i/10%6,i%10];
           
            label.font = [UIFont systemFontOfSize:10];
            [_voiceView addSubview:label];
            UIButton* btn = [UIButton new];
            
            btn.frame=CGRectMake(i*self.view.frame.size.width/5, 10, 1, 20);
            btn.backgroundColor = [UIColor grayColor];
            [_voiceView addSubview:btn];
            
        }
        //添加小标记
        
        for (int i = 0 ; i <=25; i++) {
            UIButton * btn2 = [[UIButton alloc]init];
            btn2.frame=CGRectMake(i*self.view.frame.size.width/25, 20, 1, 10);
            btn2.backgroundColor = [UIColor grayColor];
            [_voiceView addSubview:btn2];
            
        }
    }
    return _voiceView;
    
    
}

-(UIButton *)recordBtn{
    if (!_recordBtn) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, 60, 30)];
        [btn setTitle:@"录音" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        _recordBtn = btn;
    }
    return _recordBtn;
}
-(UIButton *)pauseBtn{
    
    if (!_pauseBtn) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, self.view.frame.size.height - 60, 60, 30)];
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        _pauseBtn = btn;
    }
    return _pauseBtn;
    
    
}
-(UIButton *)resumeBtn{
    
    
    if (!_resumeBtn) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(200, self.view.frame.size.height - 60, 60, 30)];
        [btn setTitle:@"恢复" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        _resumeBtn = btn;
    }
    return _resumeBtn;
    
}
-(UIButton *)stopeBtn{
    
    
    
    if (!_stopeBtn) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(300, self.view.frame.size.height - 60, 60, 30)];
        [btn setTitle:@"停止" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        _stopeBtn = btn;
    }
    return _stopeBtn;
    
    
}

-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
#pragma 按钮点击事件;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor    grayColor];
    [self.view addSubview:self.stopeBtn];
    [self.view addSubview:self.resumeBtn];
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.pauseBtn];
    [self.recordBtn addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseBtn addTarget:self action:@selector(pauseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.resumeBtn addTarget:self action:@selector(resumeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.stopeBtn addTarget:self action:@selector(stopeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.scrollView];
    [self setScrollView];
    [self setAudioSession];
}
//设置scrollView
-(void)setScrollView{
    
    self.scrollView.delegate = self;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.voiceView.frame.size.width , self.voiceView.frame.size.height);
    //开启分页
    self.scrollView.pagingEnabled = NO;
    //滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator= NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = YES;
    [self.scrollView addSubview:self.voiceView];
    
    

//     self.voiceView.
}

// 点击录音按钮
-(void)recordClick:(UIButton *)sender{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
        self.timer2.fireDate=[NSDate distantPast];
    }
        self.scrollView.scrollEnabled = NO;
}
// 点击暂定按钮
-(void)pauseClick:(UIButton *)sender{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
        self.timer2.fireDate=[NSDate distantFuture];
    }
        self.scrollView.scrollEnabled = YES;
}
//点击恢复按钮
-(void)resumeClick:(UIButton *)sender{
    [self recordClick:sender];
        self.scrollView.scrollEnabled = NO;
}
//点击停止按钮
-(void)stopeClick:(UIButton *)sender{
    [self.audioRecorder stop];
    self.array = nil;
    self.timer.fireDate=[NSDate distantFuture];
   self.timer2.fireDate=[NSDate distantFuture];
     [self.scrollView scrollRectToVisible:CGRectMake(0,0, self.voiceView.frame.size.width, self.voiceView.frame.size.height) animated:YES];

     self.scrollView.scrollEnabled = YES;
}
#pragma mark - 私有方法
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"myRecorder.caf"]];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    
    return url;
    
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL *url=[self getSavePath];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
            
        }
    }
    return _audioPlayer;
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
-(NSTimer *)timer2{
    
    if (!_timer2) {
        _timer2=[NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(changeScrollView) userInfo:nil repeats:YES];
    }
    return _timer2;

}

-(void)changeScrollView{
    float i = 0 ;
    if (IS_IPHONE_6) {
        i  = self.array.count * 1.5;
        
    }
    if (IS_IPHONE_6P) {
        i  = self.array.count * 414.0/250.0;
        
    }
    if (IS_IPHONE_5) {
        i  = self.array.count * 320.0 /250.0;
        
    }

    if (i>= self.scrollView.frame.size.width/2.0) {
        
        [self.scrollView scrollRectToVisible:CGRectMake(self.voiceView.frame.size.width*1.0 - self.view.frame.size.width*1.0,0, self.view.frame.size.width*1.0, self.view.frame.size.height) animated:YES];
    }
}


/**
 *  录音声波状态设置
 */
/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    NSNumber * number = [NSNumber numberWithFloat:power];
    [self.array addObject:number];
    
    self.voiceView.array = self.array;
    float i = 0 ;
    if (IS_IPHONE_6) {
        i  = self.array.count * 1.5;
        
    }
    if (IS_IPHONE_6P) {
        i  = self.array.count * 414.0/250.0;
        
    }
    if (IS_IPHONE_5) {
        i  = self.array.count * 320.0 /250.0;
        
    }
    
    
    if (i>= self.scrollView.frame.size.width/2.0) {
        self.voiceView.frame =CGRectMake(0, 0, self.view.frame.size.width*1.0/2.0+i,self.voiceView.frame.size.height*1.0);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*1.0/2.0+ i , self.voiceView.frame.size.height*1.0);
        UILabel * label =[UILabel new];
     label.font = [UIFont systemFontOfSize:10];
              UIButton* btn = [UIButton new];
        label.textColor = [UIColor  whiteColor];
        //添加数字
        for (int i = 0 ; i <=self.voiceView.frame.size.width *5/ self.view.frame.size.width; i++) {
            if (i >5) {
                
            
            label.frame= CGRectMake(i*self.view.frame.size.width/5+20, 10, 30, 10);
             label.text = [NSString stringWithFormat:@"%d%d:%d%d",i/600%10,i/60%10,i/10%6,i%10];
            
            [_voiceView addSubview:label];
      
            btn.frame=CGRectMake(i*self.view.frame.size.width/5, 10, 1, 20);
            btn.backgroundColor = [UIColor grayColor];
            [_voiceView addSubview:btn];
            }
        }
        //添加小标记
        UIButton * btn2 = [[UIButton alloc]init];
        for (int i = 0 ; i <=self.voiceView.frame.size.width *25/ self.view.frame.size.width; i++) {
            
            btn2.frame=CGRectMake(i*self.view.frame.size.width/25, 20, 1, 10);
            btn2.backgroundColor = [UIColor grayColor];
            [_voiceView addSubview:btn2];
            
        }
    }
    else{
        [self.scrollView scrollRectToVisible:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
        self.voiceView.frame =CGRectMake(0, 0, self.view.frame.size.width,self.voiceView.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.voiceView.frame.size.height);
        
    }
    [self.voiceView setNeedsDisplay];
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
 
    NSLog(@"录音完成!");

}

@end
