//
//  ViewController.m
//  RACSignal
//
//  Created by youzu_Max on 2017/3/29.
//  Copyright © 2017年 youzu. All rights reserved.
//

#import "ViewController.h"

#import "RACSignalViewController.h"
#import "RACSubjectViewController.h"
#import "RACReplaySubjectViewController.h"
#import "RACMulticastConnectionViewController.h"
#import "RACCommandViewController.h"
#import "MapViewController.h"
#import "SignalConnectViewController.h"
#import "SignalSelectViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"目录" ;
}


- (IBAction)RACSignal:(id)sender
{
    [self.navigationController pushViewController:[RACSignalViewController new] animated:YES];
}

- (IBAction)RACSubject:(id)sender
{

    [self.navigationController pushViewController:[RACSubjectViewController new] animated:YES];
}

- (IBAction)RACReplaySubject:(id)sender
{
  [self.navigationController pushViewController:[RACReplaySubjectViewController new] animated:YES];
}

- (IBAction)RACMulticastConnection:(id)sender
{
    [self.navigationController pushViewController:[RACMulticastConnectionViewController new] animated:YES];
}

- (IBAction)RACCommand:(id)sender
{
    [self.navigationController pushViewController:[RACCommandViewController new] animated:YES];
}

- (IBAction)map:(id)sender
{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
}

- (IBAction)connect:(id)sender
{
      [self.navigationController pushViewController:[SignalConnectViewController new] animated:YES];
}
- (IBAction)select:(id)sender
{
    [self.navigationController pushViewController:[SignalSelectViewController new] animated:YES];
}

- (IBAction)skip:(id)sender
{
    
}

@end
