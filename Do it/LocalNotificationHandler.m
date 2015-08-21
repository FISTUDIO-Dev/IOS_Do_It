//
//  LocalNotificationHandler.m
//  Do it
//
//  Created by Jackie Chung on 18/07/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LocalNotificationHandler.h"
#import "Constants.h"

@implementation LocalNotificationHandler

+(void)pushLocalNotificationWithTitle:(NSString *)action Message:(NSString *)body ScheduledAt:(NSDate *)firetime Repeat:(BOOL)value SoundName:(NSString *)soundname ExtraData:(NSDictionary *)data{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = firetime;
    localNotification.alertBody = body;
    localNotification.soundName = soundname;
    localNotification.alertAction = action;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.userInfo = data;
    if (value) {
        localNotification.repeatInterval = NSCalendarUnitDay;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+(BOOL)cancelLocalNotificationWithID:(NSString*)identifier{
    NSArray* allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for (UILocalNotification*notification in allNotifications) {
        NSString* currentUID = [notification.userInfo objectForKey:kDAILY_NOTIFICATION_TO_BE_CANCELLED_KEY];
        if ([currentUID isEqual:identifier]) {
            [[UIApplication sharedApplication]cancelLocalNotification:notification];
            return YES;
        }
    }
    return NO;
}
@end
