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

//Manipulate daily activity
//add
-(void)addDailyActivityToList:(ActivityListInstance*)instance;
//complete
-(void)completeDailyActivityAtIndex:(NSInteger)index;
-(void)completeDailyActivityIdenticalTo:(ActivityListInstance*)task;
//set redundant
-(void)setToBeRedundantTaskAtIndex:(NSInteger)index;
-(void)setTobeRedundantTaskIdenticalTo:(ActivityListInstance*)task;
//set as daily activity
-(void)setToBeDailyActivityAtIndex:(NSInteger)index;
-(void)setToBeDailyActivityIdenticalTo:(ActivityListInstance*)task;
//summarise Activities for a day
// - clean old activties
// - reload daily, redundancies and normal arrays
-(void)summariseListActivities;
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
