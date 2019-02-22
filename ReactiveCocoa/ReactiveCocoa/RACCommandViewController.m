//
//  RACCommandViewController.m
//  ReactiveCocoa
//
//  Created by youzu_Max on 2017/3/30.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "RACCommandViewController.h"

@interface RACCommandViewController ()

@property RACCommand *command ;

@property UITextField *textFiled ;

@end

@implementation RACCommandViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input){

        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"%@",input);
            MOBAWxArticleRequest * req = [MOBAWxArticleRequest wxArticleCategoryRequest];
            
            [MobAPI sendRequest:req onResult:^(MOBAResponse *response) {
                [subscriber sendNext:response.responder];
                [subscriber sendCompleted];
            }];
            
            return nil ;
        }] ;
        
        return signal ;
        
    }];


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //先订阅
    [_command.executionSignals subscribeNext:^(id  _Nullable x) {
        
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"normal -> %@",x);
        }];
    }];
    
    //也可以这样写
    [_command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"vip --> %@",x);
    }];


    //监听command的状态
    [[_command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue)
        {
            NSLog(@"excuting...");
        }
        else
        {
            NSLog(@"not excuted");
        }
    }];
    
    //在执行
    [_command execute:@"参数"];
    
}


@end
