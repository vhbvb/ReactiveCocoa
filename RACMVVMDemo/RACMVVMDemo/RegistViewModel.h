//
//  RegistViewModel.h
//  RACMVVMDemo
//
//  Created by youzu_Max on 2017/3/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface RegistViewModel : NSObject

@property (nonatomic, copy) NSString *name ;
@property (nonatomic, copy) NSString *phoneNum ;
@property (nonatomic, copy) NSString *passWord ;
@property (nonatomic, copy) NSString *verifypassWord ;
@property (nonatomic, strong ) RACCommand *registCommand ;
@property (nonatomic, strong ) RACSignal *registEnabledSignal ;

@end
