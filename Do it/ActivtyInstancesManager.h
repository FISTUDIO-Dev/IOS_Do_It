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

@interface ActivtyInstancesManager : NSObject

+(id)sharedManager;
-(instancetype)init;

-(BOOL)saveToFile;
-(void)convertToAchievementWithOngoingInstance:(OngoingActivityInstance*)instance;
-(void)convertToFailedActivityWithOngoingInstance:(OngoingActivityInstance*)instance Giveup:(BOOL)giveup;
-(NSDictionary*)constructTimeComponentsWithTimeInSecs:(long)secs;

-(void)addOngoingActivity:(OngoingActivityInstance*)activity;
-(void)deletePastAchievementInstanceIdenticalTo:(PastAcheievementActivityInstance*)instance;
-(void)deleteFailedActivityInstanceIdenticalTo:(FailedActivityInstance*)isntance;
-(void)deletePastAchievementInstanceAtIndex:(NSInteger)idx;
-(void)deleteFailedACtivityInstanceAtIndex:(NSInteger)idx;

-(NSArray*)getAllActivities;
-(NSArray*)getOngoingActivityInArray;
-(NSArray*)getPastAchievementsArray;
-(NSArray*)getFailedActivityArray;
@end
