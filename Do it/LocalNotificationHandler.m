//
//  LocalNotificationHandler.m
//  Do it
//
//  Created by Jackie Chung on 18/07/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LocalNotificationHandler.h"

@implementation LocalNotificationHandler

+(void)pushLocalNotificationWithTitle:(NSString *)action Message:(NSString *)body ScheduledAt:(NSDate *)firetime SoundName:(NSString *)soundname ExtraData:(NSDictionary *)data{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = firetime;
    localNotification.alertBody = body;
    localNotification.alertAction = action;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.userInfo = data;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
@end
