//
//  ViewController.m
//  gcdCourse1
//
//  Created by vincent_guo on 13-12-12.
//  Copyright (c) 2013年 vincent_guo. All rights reserved.
//  GCD是一个替代诸如NSThread等技术的很高效和强大的技术。

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}



#pragma mark 串行队列
//意思是要在同一个线程中 myQueues0执行完才执行myQueues1，一个个执行
-(void)start:(id)sender{
    //创建一个队列 第一个参数是标识队列的，第二个参数是用来定义队列的参数（目前不支持，因此传入NULL）
    _textField.text = @"异步串行线程执行中";
    dispatch_queue_t myQueue = dispatch_queue_create("com.aini.q1", NULL);
    
    //把myQueue1这个队列放在异步线程中去执行 这里让其停留13秒
    dispatch_async(myQueue, ^{
        NSLog(@"%@ %@",@"myQueues0",[NSThread currentThread]);
        for (int i=0; i< 3; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"myQueues0 run %i",i);
        }
        
        //要用dispatch_sync（同步）在主线程中执行UI更新操作，
        dispatch_sync(dispatch_get_main_queue(), ^{
            _textField.text = @"异步串行线程0执行完毕";
        });
    });
    
    dispatch_async(myQueue, ^{
        NSLog(@"%@ %@",@"myQueues1",[NSThread currentThread]);
        for (int i=0; i< 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"myQueues1 run %i",i);
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            _textField.text = @"异步串行线程1执行完毕";
        });
    });

    dispatch_release(myQueue);
}

#pragma mark 并行队列
//意思是要myQueues0 myQueues1在不同线程同时执行
-(void)start2:(id)sender{
    _textField.text = @"异步并行线程执行中";
    //创建一个并行队列
    dispatch_queue_t myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(myQueue,^{
        NSLog(@"%@ %@",@"myQueues0",[NSThread currentThread]);
        for (int i=0; i< 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"myQueues0 run %i",i);
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            _textField.text = @"异步并行线程0执行完毕";
        });
    });
    
    dispatch_async(myQueue,^{
        NSLog(@"%@ %@",@"myQueues1",[NSThread currentThread]);
        for (int i=0; i< 7; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"myQueues1 run %i",i);
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            _textField.text = @"异步并行线程1执行完毕";
        });
    });
}

-(void)start3:(id)sender{
    _textField.text = @"停留4秒执行中";
    double delayInSeconds = 4.0;
    //从现在开始计算4秒
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //4秒过后会调用block里面的方法 ，在主线程中调用方法来更改UI
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _textField.text = @"停留完闭中";
    });
}

@end
