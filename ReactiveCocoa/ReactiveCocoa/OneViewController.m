//
//  OneViewController.m
//  RACSignal
//
//  Created by youzu_Max on 2017/3/29.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "OneViewController.h"
#import "TwoViewController.h"

@interface OneViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)jump:(id)sender
{
    TwoViewController * vc = [TwoViewController new];
    
    vc.subject = [RACSubject subject];
    
    [vc.subject subscribeNext:^(id  _Nullable x) {
        
        NSNumber * index = x ;
        _name.text = @[@"小明",@"小华",@"小芳"][index.intValue];
        
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
