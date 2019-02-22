//
//  RACMulticastConnectionViewController.m
//  ReactiveCocoa
//
//  Created by youzu_Max on 2017/3/30.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "RACMulticastConnectionViewController.h"

@interface RACMulticastConnectionViewController ()
{
    RACSignal *_signal ;
    id<RACSubscriber>  _Nonnull _subscriber ;
}

@end

@implementation RACMulticastConnectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block NSInteger times ;
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"--->%@ ,times:%zd",subscriber,++times);
        
        _subscriber = subscriber ;
        
        return nil ;
    }];
    
//    [signal subscribeNext:^(id  _Nullable x) {
//        
//        NSLog(@"1 --> %@",x);
//    }];
//    
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"2 --> %@",x);
//    }];
    
//    _signal = signal ;
    
    static RACMulticastConnection *connect = nil ;
    
    if (!connect)
    {
        connect = [signal publish] ;
    }
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMulticastConnection  -->   %@",x);
    }];
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMulticastConnection  -->   %@",x);
    }];
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMulticastConnection  -->   %@",x);
    }];
    
    [connect connect];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_subscriber sendNext:@"sendedData"];
}


@end
