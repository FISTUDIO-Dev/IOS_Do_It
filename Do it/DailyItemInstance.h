//
//  DailyItemInstance.h
//  Do it
//
//  Created by Jackie Chung on 18/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyItemInstance : NSObject

@property (strong,nonatomic) NSString* content;

@property (strong,nonatomic) NSDateComponents* reminderDate;

@property (strong,nonatomic) NSNumber* completionRate;

@property (strong,nonatomic) NSString* optionalEventIdentifier;

-(instancetype)initWithContent:(NSString*)content Reminder:(NSDateComponents*)reminderDate;

-(NSInteger)daysOfCreation;

-(void)complete;

-(NSDate*)getCreationDate;


@end
