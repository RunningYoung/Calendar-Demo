//
//  ViewController.m
//  Calendar-Demo
//
//  Created by xcl on 16/5/5.
//  Copyright © 2016年 xcl. All rights reserved.
//

#import "ViewController.h"
#import <EventKit/EventKit.h>
#import "ZCCustomCalendar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 100, 50);
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:@"创建日历时间" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)saveEvent:(id)sender {

    [[ZCCustomCalendar shareCustomCalendar] createCalendarEventTitle:@"每周例会"
                                      location:@"天津会议室"
                                     startDate:[[NSDate alloc]init ]
                                       endDate:[[NSDate alloc]init ]
                                        allDay:YES
                                viewController:self
                                    alarmArray:@[[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24],
                                                 [EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]]
                                  successBlock:^(BOOL success) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
