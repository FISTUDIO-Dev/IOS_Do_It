//
//  ActivityListInstance.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/8/17.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivityListInstance.h"
@interface ActivityListInstance(){
    NSString *uid;
}
@property (assign,nonatomic) BOOL isCompleted;
@property (assign,nonatomic) BOOL isRedundant;
@property (assign,nonatomic) BOOL isDaily;
@property (strong,nonatomic,setter=setReminder:,getter=getReminderDate) NSDate* reminderDate;
@end

@implementation ActivityListInstance

#pragma mark - Initialize
-(id)init{
    [NSException raise:@"Use designated initialize" format:@"Initialize with task content"];
    return nil;
}

-(id)initListTaskWithContent:(NSString *)value{
    self = [super init];
    if (self) {
        _taskContent = value;
        _createdDate = [NSDate date];
        self.isRedundant = NO;
        self.isDaily = NO;
        self.reminderDate = nil;
        uid = [NSString stringWithFormat:@"%ld",[_taskContent hash]];
    }
    return self;
}

#pragma mark - Getters and Setters
-(BOOL)isCompleted{
    return self.isCompleted;
}

-(void)setCompleted:(BOOL)value{
    self.isCompleted = value;
}

-(BOOL)isRedundant{
    return self.isRedundant;
}
-(void)setRedundancy:(BOOL)value{
    self.isRedundant = value;
}
-(BOOL)isDailyRoutine{
    return self.isDaily;
}
-(void)setTobeDailyRoutine:(BOOL)value{
    self.isDaily = value;
}
-(void)setReminder:(NSDate *)date{
    if (self.isDaily) {
        self.reminderDate = date;
    }else{
        [NSException raise:@"Non-daily activities should not be assigned a reminder!" format:@"Set daily first!"];
    }
}
-(NSDate*)getReminderDate{
    return self.reminderDate;
}

-(NSString*)getuid{
    return uid;
}
@end
