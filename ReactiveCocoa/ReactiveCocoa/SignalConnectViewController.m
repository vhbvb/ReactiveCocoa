//
//  SignalConnectViewController.m
//  ReactiveCocoa
//
//  Created by youzu_Max on 2017/3/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SignalConnectViewController.h"

@interface SignalConnectViewController ()

@end

@implementation SignalConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
}

//按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
- (IBAction)concat:(id)sender
{
    NSLog(@"****************** concat ******************");
    
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
//    id<RACSubscriber>  __block subscriberC ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
//    RACSignal * signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        subscriberC = subscriber ;
//        return nil ;
//    }];
    
//    [signalA subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
//    
//    [signalB subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    RACSignal *concatSignal = [signalA concat:signalB] ;
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"concat:%@",x);
    }];
    
    [subscriberB sendNext:@"B"];
    [subscriberA sendNext:@"A"];
    [subscriberA sendCompleted];//一定要调complete
    [subscriberB sendNext:@"B2"];
    [subscriberB sendCompleted];

//    [subscriberC sendNext:@"C"];
//    [subscriberA sendCompleted];
  
}

//用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
- (IBAction)then:(id)sender
{
    NSLog(@"****************** then ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberThen ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalThen = [signalA then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            subscriberThen = subscriber ;
            return nil ;
        }];
    }];
    
    //  A的订阅会被忽略掉。
    [signalA subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signalThen subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subscriberA sendNext:@"A"];
    [subscriberA sendCompleted];//一定要调complete
    
    [subscriberThen sendNext:@"B"];
    [subscriberThen sendCompleted];
    
}

//把多个信号合并为一个信号，任何一个信号有新值的时候就会调用.
- (IBAction)merge:(id)sender
{
    NSLog(@"****************** merge ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subscriberA sendNext:@"A sended"];
    [subscriberB sendNext:@"B sended"];
    
}

- (IBAction)zipWith:(id)sender
{
    
    NSLog(@"****************** zipWith ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subscriberA sendNext:@"A sended"];
    [subscriberB sendNext:@"B sended"];
    [subscriberA sendNext:@"A sended2"];
    [subscriberB sendNext:@"B sended2"];
}

// 将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
- (IBAction)combineLatest:(id)sender
{
    
    NSLog(@"****************** combineLatest ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
    id<RACSubscriber>  __block subscriberC ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberC = subscriber ;
        return nil ;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
//    RACSignal *combineSignal = [[signalA combineLatestWith:signalB] combineLatestWith:signalC];
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[signalA,signalB,signalC]];

    [combineSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subscriberA sendNext:@"A sended"];
    [subscriberA sendNext:@"A sended 2"];
    
    [subscriberB sendNext:@"B sended"];
    
    [subscriberC sendNext:@"C sended"];
    [subscriberC sendNext:@"C sended 2"];
}

// 就是combine 发送的信号 在reduce block里面处理后发送出去。
- (IBAction)reduce:(id)sender
{
    
    NSLog(@"****************** combineLatest ******************");
    id<RACSubscriber>  __block subscriberA ;
    id<RACSubscriber>  __block subscriberB ;
    id<RACSubscriber>  __block subscriberC ;
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberA = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberB = subscriber ;
        return nil ;
    }];
    
    RACSignal * signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        subscriberC = subscriber ;
        return nil ;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    //    RACSignal *combineSignal = [[signalA combineLatestWith:signalB] combineLatestWith:signalC];
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[signalA,signalB,signalC] reduce:^id(NSString *a,NSString *b,NSString *c){
        
        return [@[a,b,c] componentsJoinedByString:@" + "];
    }];
    
    [combineSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subscriberA sendNext:@"A sended"];
    [subscriberA sendNext:@"A sended 2"];
    
    [subscriberB sendNext:@"B sended"];
    
    [subscriberC sendNext:@"C sended"];
    [subscriberC sendNext:@"C sended 2"];
}

@end
