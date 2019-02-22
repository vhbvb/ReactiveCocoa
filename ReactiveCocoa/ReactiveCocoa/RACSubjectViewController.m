//
//  RACSubjectViewController.m
//  RACSignal
//
//  Created by youzu_Max on 2017/3/29.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "RACSubjectViewController.h"
#import "OneViewController.h"
@interface RACSubjectViewController ()

@end

@implementation RACSubjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RACSubject * subject = [RACSubject subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"张三先关注一波:%@",x]);
    }];
    

    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"李四也关注一波:%@",x]);
    }];
    
    [subject sendNext:@"大红包"];

}


- (IBAction)delegateTest:(id)sender
{
    [self.navigationController pushViewController:[OneViewController new] animated:YES];
}

@end
