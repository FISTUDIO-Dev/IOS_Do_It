//
//  ActivtyInstancesManager.h
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/19.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OngoingActivityInstance.h"
#import "PastAcheievementActivityInstance.h"
#import "FailedActivityInstance.h"
#import "ActivityListInstance.h"
@interface ActivtyInstancesManager : NSObject

+(id)sharedManager;
-(instancetype)init;

-(BOOL)saveToFile;
-(void)convertToAchievementWithOngoingInstance:(OngoingActivityInstance*)instance;
-(void)convertToFailedActivityWithOngoingInstance:(OngoingActivityInstance*)instance Giveup:(BOOL)giveup;
-(void)convertToOngoingInstanceWithFailedInstance:(FailedActivityInstance*)instance AndTime:(long)secs;

-(NSDictionary*)constructTimeComponentsWithTimeInSecs:(long)secs;

-(void)addOngoingActivity:(OngoingActivityInstance*)activity;
-(void)deletePastAchievementInstanceIdenticalTo:(PastAcheievementActivityInstance*)instance;
-(void)deleteFailedActivityInstanceIdenticalTo:(FailedActivityInstance*)isntance;
-(void)deletePastAchievementInstanceAtIndex:(NSInteger)idx;
-(void)deleteFailedActivityInstanceAtIndex:(NSInteger)idx;

-(void)addListActivity:(ActivityListInstance*)taskInstance;
-(void)completeListActivityAtIndex:(NSInteger)index;
-(void)completeRedundantActivityAtIndex:(NSInteger)index;
-(void)completeDailyActivityAtIndex:(NSInteger)index;
-(void)setToBeRedundantTaskAtIndex:(NSInteger)index;
-(void)setToBeDailyActivityAtIndex:(NSInteger)index;
-(void)removeFromDailyActivitiesWithIndex:(NSInteger)index;
-(void)setReminderForDailyActivityWithIndex:(NSInteger)index AndTime:(NSDate*)date;
-(void)summariseListActivities;
-(void)convertListItem:(ActivityListInstance*)listActivity toTask:(OngoingActivityInstance*)ongoingTask WithSetTimeLimit:(long)secs;

//get redundants array
-(NSArray*)getRedundantActivitiesArray;
//get daily routine array
-(NSArray*)getDailyActivitiesArray;
//get normal tasks array
-(NSArray*)getNormalActivitiesArray;

-(NSArray*)getOngoingActivityInArray;
-(OngoingActivityInstance*)getOngoingInstance;
-(NSArray*)getPastAchievementsArray;
-(NSArray*)getFailedActivityArray;
@end
