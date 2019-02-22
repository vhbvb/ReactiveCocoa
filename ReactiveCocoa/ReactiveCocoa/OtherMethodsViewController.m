//
//  OtherMethodsViewController.m
//  ReactiveCocoa
//
//  Created by youzu_Max on 2017/3/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "OtherMethodsViewController.h"

@interface OtherMethodsViewController ()
{
    id<RACSubscriber>  _subscriber ;
    id<RACSubscriber>  _delaySubscriber ;
}

@end

@implementation OtherMethodsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self doNext];
//    [self timeout];
//    [self timer];
//    [self retry];
    [self replay];
    [self throttle];
}

- (void)doNext
{
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        _subscriber = subscriber ;
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@"1"];之前会调用这个Block
        NSLog(@"%@",[x stringByAppendingString:@"doNext"]);
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");;
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

- (void)timeout
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {\
        
        //发送一个延时请求。
        return nil;
    }] timeout:10 onScheduler:[RACScheduler currentScheduler]];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        // 10秒后会自动调用
        NSLog(@"%@",error);
    }];
}

- (void)timer
{
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        
        NSLog(@"timer : %@",x);
    }];
}

- (void)delay
{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        _delaySubscriber = subscriber ;
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

// 只要失败，就会重新执行创建信号中的block,直到成功
- (void)retry
{
    __block int i = 10;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (i--) {
            NSLog(@"报一个错误");
            [subscriber sendError:nil];
        }
        else
        {
           [subscriber sendNext:@"重要不报错了"];
        }
        return nil;
        
    }] retry] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    } error:^(NSError *error) {
        
        
    }];
}

- (void)replay
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者%@",x);
        
    }];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者%@",x);
        
    }];
}

// 节流
- (void)throttle
{
    RACSubject *signal = [RACSubject subject];
    // 节流，在一定时间（10秒）内，不接收任何信号内容，过了这个时间（10秒）获取最后发送的信号内容发出。
    [[signal throttle:10] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_subscriber sendNext:@"1"];
    [_delaySubscriber sendNext:@"delay"];
    [_subscriber sendCompleted];
}

@end
