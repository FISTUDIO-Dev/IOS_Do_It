//
//  LocalNotificationHandler.h
//  Do it
//
//  Created by Jackie Chung on 18/07/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNNotificationsUI_iOS7.1.h"
@interface LocalNotificationHandler : NSObject

// In app local notification <- LNNotification
+(void)showInAppLocalNotificationWithTitle:(NSString *)title Message:(NSString *)message ImageName:(NSString *)imagename SoundName:(NSString*)soundname TappedAction:(LNNotificationAction *)action RegisteredIdentifier:(NSString *)identifier RegisteredName:(NSString *)name;

// Standard local notification
+(void)pushLocalNotificationWithTitle:(NSString*)action Message:(NSString*)body ScheduledAt:(NSDate*)firetime SoundName:(NSString*)soundname ExtraData:(NSDictionary*)data;
@end
