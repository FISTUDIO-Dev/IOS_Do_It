//
//  LocalNotificationHandler.m
//  Do it
//
//  Created by Jackie Chung on 18/07/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "LocalNotificationHandler.h"

@implementation LocalNotificationHandler

+(void)showInAppLocalNotificationWithTitle:(NSString *)title Message:(NSString *)message ImageName:(NSString *)imagename SoundName:(NSString*)soundname TappedAction:(LNNotificationAction *)action RegisteredIdentifier:(NSString *)identifier RegisteredName:(NSString *)name{
    [[LNNotificationCenter defaultCenter]registerApplicationWithIdentifier:identifier name:name icon:[UIImage imageNamed:imagename]  defaultSettings:LNNotificationDefaultAppSettings];
    
    LNNotification * notification = [LNNotification notificationWithTitle:title message:message];
    if (soundname !=nil) {
        notification.soundName = soundname;
    }
    if (action != nil) {
        notification.defaultAction = action;
    }
    
    [[LNNotificationCenter defaultCenter]presentNotification:notification forApplicationIdentifier:identifier];
}

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
