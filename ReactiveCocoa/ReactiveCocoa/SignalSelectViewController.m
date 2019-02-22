//
//  SignalSelectViewController.m
//  ReactiveCocoa
//
//  Created by youzu_Max on 2017/3/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "SignalSelectViewController.h"

@interface SignalSelectViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SignalSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 过滤信号，使用它可以获取满足条件的信号 */
    [[_textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        
        NSLog(@"filter :%@",value);
        return value.length > 3 ;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"filter -> %@",x);
    }];
    
    /* 忽略完某些值的信号 */
    [[_textField.rac_textSignal ignore:@"MOB"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"ignore ->%@",x);
    }];
    
    /* 当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉 */
    [[_textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        
        NSLog(@"distinctUntilChanged -> %@",x);
    }];
    
    //这2个演示不出来，因为是封装好自动发送的
//    [[_textField.rac_textSignal take:2] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"take -> %@",x);
//    }];
//    
//    [[_textField.rac_textSignal takeLast:3] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"takeLast -> %@",x);
//    }];
    
    /* 获取信号直到执行完这个信号 */
    [[_textField.rac_textSignal takeUntil:_textField.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"takeUntil -> %@",x);
    }];
    
    /* (NSUInteger):跳过几个信号,不接受 */
    [[_textField.rac_textSignal skip:2] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"skip -> %@",x);
    }];
    
    [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"***************************************");
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.editing = NO ;
}

@end
