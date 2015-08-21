//
//  LocalNotificationHandler.h
//  Do it
//
//  Created by Jackie Chung on 18/07/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LocalNotificationHandler : NSObject

// Standard local notification
+(void)pushLocalNotificationWithTitle:(NSString*)action Message:(NSString*)body ScheduledAt:(NSDate*)firetime Repeat:(BOOL)value SoundName:(NSString*)soundname ExtraData:(NSDictionary*)data;
+(BOOL)cancelLocalNotificationWithID:(NSString*)identifier;
@end
