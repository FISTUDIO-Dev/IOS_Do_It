//
//  ActivityListInstance.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/8/17.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivityListInstance.h"
@interface ActivityListInstance(){
    NSInteger redundantDays;
    
    NSDate* dateCreatedAsDaily;
    NSInteger completedDailyTimes;
    float dailyCompletionRate;
}
//first level
@property (assign,nonatomic) BOOL isCompleted;
@property (assign,nonatomic) BOOL isRedundant;
@property (assign,nonatomic) BOOL isDaily;

//second level configurable
@property (strong,nonatomic,setter=setReminder:,getter=getReminderDate) NSDate* reminderDate;
@property (strong,nonatomic) NSString* dailyCompletionString;
@property (strong,nonatomic) NSString* redundantDaysString;
//hidden
@property (strong,nonatomic) NSString* uid;
@end

@implementation ActivityListInstance

#pragma mark - Initialize
-(id)init{
    [NSException raise:@"Use designated initialization" format:@"Initialize with task content"];
    return nil;
}

-(id)initListTaskWithContent:(NSString *)value{
    self = [super init];
    if (self) {
        //First level
        _taskContent = value;
        _createdDate = [NSDate date];
        self.uid = [NSString stringWithFormat:@"%ld",(unsigned long)[_taskContent hash]];
    }
    return self;
}

#pragma mark - Getters and Setters
-(BOOL)isCompleted{
    return self.isCompleted;
}

-(void)setCompleted:(BOOL)value{
    self.isCompleted = value;
    //if detected redundant-> remove the redundancy
    if (self.isRedundant) {
        [self setRedundancy:NO];
    }
    //if detected daily -> increase activty counter
    if (self.isDaily) {
        completedDailyTimes++;
    }
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
    dateCreatedAsDaily = [NSDate date];
}
-(void)setReminder:(NSDate *)date{
    self.reminderDate = date;
}
-(NSDate*)getReminderDate{
    return self.reminderDate;
}

-(NSString*)getuid{
    return self.uid;
}

#pragma mark - configurable
-(void)incrementRedundancy{
    redundantDays++;
    self.redundantDaysString = [NSString stringWithFormat:@"%i",(int)redundantDays];
}

-(void)refreshDailyCounter{
    //Set completion time
    int daysSinceCreation = [[NSDate date] timeIntervalSinceDate:dateCreatedAsDaily]/86400 < 1?1:[[NSDate date] timeIntervalSinceDate:dateCreatedAsDaily]/86400;
    dailyCompletionRate = completedDailyTimes/daysSinceCreation;
    self.dailyCompletionString = [NSString stringWithFormat:@"%f%%",ceilf(dailyCompletionRate)];
    //Reset
    completedDailyTimes = 0;
}

@end
