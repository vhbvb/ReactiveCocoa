//
//  ViewController.m
//  RACMVVMDemo
//
//  Created by youzu_Max on 2017/3/31.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "ViewController.h"
#import "RegistViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "NSString+MAXCommon.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *verifyPassword;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property (strong, nonatomic) RegistViewModel * viewModel ;

@property (weak, nonatomic) IBOutlet UILabel *nameAlert;
@property (weak, nonatomic) IBOutlet UILabel *phoneAlert;
@property (weak, nonatomic) IBOutlet UILabel *passwordAlert;
@property (weak, nonatomic) IBOutlet UILabel *verifyPasswordAlert;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewModel = [[RegistViewModel alloc] init];
    
    [self binds];
    
    [[_registBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [_viewModel.registCommand execute:@"params"];
    }];
    
    [_viewModel.registCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"注册反馈（其实是微信精选）：%@",x);
    }];
    
}

- (void)binds
{
    // 其实viewmodel属性可以是直接是信号。
    RAC(self.viewModel,name) = _name.rac_textSignal ;
    RAC(self.viewModel,phoneNum) = _phoneNum.rac_textSignal ;
    RAC(self.viewModel,passWord) = _password.rac_textSignal ;
    RAC(self.viewModel,verifypassWord) = _verifyPassword.rac_textSignal;
    RAC(self.registBtn,enabled) = self.viewModel.registEnabledSignal ;

/*  这段理论上也应该抽到viewModel里面 */
    RAC(self.nameAlert,text) = [_name.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [value isUserName] ? @"✅":@"❌" ;
    }];
    
    RAC(self.phoneAlert,text) = [_phoneNum.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [value isPhoneNumber] ? @"✅":@"❌";
    }];
    
    RAC(self.passwordAlert,text) = [_password.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [value isPassword] ? @"✅":@"❌";
    }];
    
    RAC(self.verifyPasswordAlert,text) = [_verifyPassword.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [value isPassword] && [value isEqualToString:_password.text] ? @"✅":@"❌";
    }];
    
}


- (IBAction)regist:(id)sender
{

}




@end
