//
//  RACReplaySubjectViewController.m
//  RACSignal
//
//  Created by youzu_Max on 2017/3/29.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "RACReplaySubjectViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RACReplaySubjectViewController ()

@end

@implementation RACReplaySubjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //大家好，我是土豪
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    //张三关注了土豪
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"张三收到红包：%@",x]);
    }];
    
    //土豪发红包了
    [replaySubject sendNext:@"1个亿"];
    
    //李四看张三发财了也关注了土豪，并表示红包没抢到，要求重发
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"李四收到红包：%@",x]);
    }];
    
    //土豪表示，钱不是问题，不但重发，还把之前你没抢到的也发给你。
    [replaySubject sendNext:@"1毛钱"];
    
}



@end
