//
//  TwoViewController.m
//  RACSignal
//
//  Created by youzu_Max on 2017/3/29.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)change:(UISegmentedControl *)sender
{
    if (_subject)
    {
        [_subject sendNext:@(sender.selectedSegmentIndex)];
    }
}


@end
