//
//  RegistViewModel.m
//  RACMVVMDemo
//
//  Created by youzu_Max on 2017/3/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "RegistViewModel.h"
#import "NSString+MAXCommon.h"
#import <MobAPI/MobAPI.h>

@implementation RegistViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSArray * signals = @[RACObserve(self, name),RACObserve(self, phoneNum),RACObserve(self, passWord),RACObserve(self,verifypassWord)];
    
    _registEnabledSignal = [RACSignal combineLatest:signals reduce:^id(NSString *name,NSString *phoneNum,NSString *passWord,NSString *verifyPassword)
    {
        
        NSLog(@"%@,%@,%@,%@",name,passWord,passWord,verifyPassword);
        return @([name isUserName] && [phoneNum isPhoneNumber] && [passWord isPassword] && [passWord isEqualToString:verifyPassword]);
    }];
    
    _registCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"input:%@",input);
            
            [MobAPI sendRequest:[MOBAWxArticleRequest wxArticleCategoryRequest] onResult:^(MOBAResponse *response) {
                [subscriber sendNext:response.responder];
                [subscriber sendCompleted];
            }];
            
            return nil ;
        }];
        
        return signal ;
    }];
}

@end
