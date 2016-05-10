//
//  ZCCustomCalendar.h
//  Calendar-Demo
//
//  Created by xcl on 16/5/5.
//  Copyright © 2016年 xcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>

@interface ZCCustomCalendar : NSObject
+ (instancetype)shareCustomCalendar;
/**
 *  创建日历事件，并添加到手机自带的日历中去，可实现闹铃提醒的功能
 *
 *  @param title      事件标题
 *  @param location   事件位置
 *  @param startDate  开始时间
 *  @param endDate    结束事件
 *  @param allDay     是否全天
 *  @param alarmArray 闹钟集合
 *  @param block      回调方法
 */
- (void)createCalendarEventTitle:(NSString *)title
                        location:(NSString *)location
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate
                          allDay:(BOOL)allDay
                  viewController:(UIViewController *)viewController
                      alarmArray:(NSArray *)alarmArray
                    successBlock:(void (^) (BOOL success))block;

@end
