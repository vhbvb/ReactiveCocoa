//
//  RACSignalViewController.m
//  RACSignal
//
//  Created by youzu_Max on 2017/3/29.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "RACSignalViewController.h"


@interface RACSignalViewController ()

@property(nonatomic,strong) id subscriber ;

@end

@implementation RACSignalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"block excute");
        [subscriber sendNext:@"haha"];
        _subscriber = subscriber ;//如果不保存的话就会自动[subscriber sendCompleted];

        RACDisposable * disponse = [RACDisposable disposableWithBlock:^{
            NSLog(@"当信号发送完成或者发送错误，就会自动执行这个block,执行完Block后，当前信号就不在被订阅了。");
        }];
        
        return disponse ;
    }];
    
    // 订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"1->receive:%@",x]);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"2->receive:%@",x]);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_subscriber sendNext:@"lol"];
    [_subscriber sendCompleted];
    [_subscriber sendNext:@"lalala"]; // 不会执行
}

@end

