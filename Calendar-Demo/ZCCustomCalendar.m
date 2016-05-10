//
//  ZCCustomCalendar.m
//  Calendar-Demo
//
//  Created by xcl on 16/5/5.
//  Copyright © 2016年 xcl. All rights reserved.
//

#import "ZCCustomCalendar.h"

@implementation ZCCustomCalendar

static ZCCustomCalendar *calendar;
+ (instancetype)shareCustomCalendar{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[ZCCustomCalendar alloc]init];
    });

    return calendar;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [super allocWithZone:zone];
    });
    return calendar;
}

- (void)createCalendarEventTitle:(NSString *)title
                        location:(NSString *)location
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate
                          allDay:(BOOL)allDay
                  viewController:(UIViewController *)viewController
                      alarmArray:(NSArray *)alarmArray
                    successBlock:(void (^) (BOOL success))block{
    __weak typeof(self) weakSelf = self;
    //事件市场
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //6.0及以上通过下面方式写入事件
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (error)
                {
                    [strongSelf showAlert:@"添加失败，请稍后重试。。。" viewController:viewController];
                    //错误细心
                    // display error message here
                    block(NO);
                }
                else if (!granted)
                {
                    [strongSelf showAlert:@"添加失败，请先授权。。。" viewController:viewController];
                    //被用户拒绝，不允许访问日历
                    // display access denied error message here
                }
                else
                {
                    // access granted
                    // ***** do the important stuff here *****
                    //事件保存到日历
                    //创建事件
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = title;
                    event.location = location;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    event.startDate = startDate;
                    event.endDate   = endDate;
                    event.allDay = allDay;
                    
                    //添加提醒
                    if (alarmArray && alarmArray.count > 0) {
                        for (EKAlarm *alarm in alarmArray) {
                            [event addAlarm:alarm];
                        }
                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    [strongSelf showAlert:@"已添加到系统日历中，请注意查看。。。" viewController:viewController];
                    NSLog(@"保存成功");
                    block(YES);
                }
            });
        }];
    }
}

- (void)showAlert:(NSString *)message viewController:(UIViewController *)vc{
    __weak typeof(vc) weakSelf = vc;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alert addAction:alertAction];
    [vc presentViewController:alert animated:YES completion:^{
        
    }];

}
@end
