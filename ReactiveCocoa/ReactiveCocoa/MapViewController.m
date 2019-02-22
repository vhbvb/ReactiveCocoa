//
//  MapViewController.m
//  ReactiveCocoa
//
//  Created by youzu_Max on 2017/3/30.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UILabel *map;
@property (weak, nonatomic) IBOutlet UILabel *flattenMap;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RAC(self,map.text) = [self.input.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [@"map + " stringByAppendingString:value];
    }];
    
    RAC(self,flattenMap.text) = [self.input.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        return [RACSignal return:[@"flattenMap + " stringByAppendingString:value]];
    }];
    
}



@end
