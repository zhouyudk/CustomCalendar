//
//  ViewController.m
//  CustomCalendar
//
//  Created by XQ on 15-2-26.
//  Copyright (c) 2015年 XQ. All rights reserved.
//



#import "ViewController.h"
#import "calendarViewController.h"

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn1:(UIButton*)sender
{
    
    calendarViewController *calendarController = [[calendarViewController alloc] initWithNibName:@"calendarViewController" bundle:nil];
    [self.navigationController pushViewController:calendarController animated:YES];
}


@end
