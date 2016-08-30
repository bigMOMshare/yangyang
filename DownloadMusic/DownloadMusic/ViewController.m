//
//  ViewController.m
//  DownloadMusic
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 wxhl. All rights reserved.
//  ai,zhen rang ren tou teng ,xin shi duo ,lu dai ma

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation ViewController

//移除观察者
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
      [self.view removeObserver:self forKeyPath:@"fractionCompleted"];
}



- (void)viewDidLoad {
      [super viewDidLoad];
      

}



- (IBAction)clipAction:(id)sender {
      //构造一个网络管理者
      AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
      //下载地址
      NSURL *netUrl = [NSURL URLWithString:@"http://www.itinge.com/music/3/9158.mp3"];
      //根据下载地址进行网络请求
      NSURLRequest *request = [NSURLRequest requestWithURL:netUrl];
      
//      NSProgress *progress = nil;
      //执行下载
      NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //打印下载进度的数据
            NSLog(@"%f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
            
            
      } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            //指定缓存路径,需要返回一个存储路径
            NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/star.mp3"];
            
            NSLog(@"打印地址：%@",savePath);
            NSURL *saveUrl = [NSURL fileURLWithPath:savePath];
            
            return saveUrl;
            
            
      } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            NSLog(@"下载成功回调");
      }];
      
      [task resume];
      
      //监听当前下载进度
      NSProgress *progressValue = [manager downloadProgressForTask:(NSURLSessionDownloadTask *)task];
      //已经下载完成的部分
      double value = progressValue.fractionCompleted;
      
      //观察者观察一个实例对象的属性变化
      [progressValue addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
      
      //简单的通过扩展方法也可以显示进度条,通过KVC
//      [_progress setProgressWithDownloadProgressOfTask:task animated:YES];
      
      
}

//添加观察者会自动执行下面方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
      NSLog(@"%@",change);
      NSNumber *value = change[@"new"];
      
      dispatch_async(dispatch_get_main_queue(), ^{
            //进度条显示下载进度
            _progress.progress = [value doubleValue];


      });
      
}

@end
