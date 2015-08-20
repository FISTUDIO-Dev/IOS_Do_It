//
//  ActivtyInstancesManager.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/19.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivtyInstancesManager.h"
#import "GlobalNoticeHandler.h"
#import "Constants.h"
@interface ActivtyInstancesManager(){
    //Use this for storing data
    NSDictionary* activitiesDictionary;
    
    //Task mode
    NSMutableArray* ongoingActivityArray;
    NSMutableArray* pastAchievementArray;
    NSMutableArray* failedActivityArray;
    
    //List mode
    NSMutableArray* dailyListActivityArray;
    NSMutableArray* redundantListActivityArray;
    NSMutableArray* normalListActivityArray;
    
}

@end
@implementation ActivtyInstancesManager


#pragma mark - Constructors
+(id)sharedManager{
    
    static ActivtyInstancesManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^(void){
        manager = [[self alloc]init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        if ([self dataExists]) {
            
            [self loadFileToDictionary];
            
        }else{
            //Task mode
            ongoingActivityArray = [[NSMutableArray alloc]init];
            pastAchievementArray = [[NSMutableArray alloc]init];
            failedActivityArray  = [[NSMutableArray alloc]init];
            
            //Daily mode
            dailyListActivityArray = [[NSMutableArray alloc]init];
            redundantListActivityArray = [[NSMutableArray alloc]init];
            normalListActivityArray = [[NSMutableArray alloc]init];
    
        }
    }
    return self;
}

#pragma mark - Task Instance Managements
//Conversion
- (void)convertToAchievementWithOngoingInstance:(OngoingActivityInstance*)instance{
    //Remove ongoing activity
    [ongoingActivityArray removeLastObject];
    //Extract data
    NSString *title = instance.activtyTitle;
    NSString *desc = instance.activityDescription;
    NSDate* date = [NSDate date];
    long remainingSecs = instance.remainingSecs;
    NSInteger delayedTimes = instance.delayedTimes;
    //Create past acheivement instance
    PastAcheievementActivityInstance * achievement = [[PastAcheievementActivityInstance alloc]initWithFinishedTitle:title Description:desc finishedDate:date remainingSecs:remainingSecs delayTimes:delayedTimes];
    [pastAchievementArray addObject:achievement];
}

-(void)convertToFailedActivityWithOngoingInstance: (OngoingActivityInstance*)instance Giveup:(BOOL)giveup {
    //Extract data
    NSString *title = instance.activtyTitle;
    NSString *desc = instance.activityDescription;
    NSDate* date = [NSDate date];
    long secs = instance.initialTime;
    //Create failed activity instance
    FailedActivityInstance *failedInstance;
    if (giveup) {
        failedInstance = [[FailedActivityInstance alloc]initWithFailedTitle:title Description:desc Date:date TrialTime:secs gaveUp:YES];
    }else{
        failedInstance = [[FailedActivityInstance alloc]initWithFailedTitle:title Description:desc Date:date TrialTime:secs gaveUp:NO];
    }
    [failedActivityArray addObject:failedInstance];
    //Remove ongoing activity
    [ongoingActivityArray removeLastObject];
    
}

-(void)convertToOngoingInstanceWithFailedInstance: (FailedActivityInstance*)instance AndTime:(long)secs{
    NSString * failedTitle = instance.failedTitle;
    NSString * failedDescription = instance.failedDescription;
    //delete old instance
    [self deleteFailedActivityInstanceIdenticalTo:instance];
    //create new ongoing instance
    OngoingActivityInstance* newInstance = [[OngoingActivityInstance alloc]initWithTitle:failedTitle mainDescription:failedDescription remainingSecs:secs];
    if (ongoingActivityArray.count == 0) {
        [ongoingActivityArray addObject:newInstance];
    }else{
        [GlobalNoticeHandler createInformationalAlertViewWithTitle:@"Oops" Description:@"Hey ! You have an ongoing task ! Please do it first!" ButtonText:@"I Get It"];
    }
}

//Ongoing activity
//---- Add
-(void)addOngoingActivity:(OngoingActivityInstance*)activity{
    if (ongoingActivityArray.count > 0) {
        [ongoingActivityArray removeAllObjects];
    }
    [ongoingActivityArray addObject:activity];
}

//Past Achievement
// ---- Delete
-(void)deletePastAchievementInstanceIdenticalTo:(PastAcheievementActivityInstance*)instance{
    NSUInteger findIndex = [pastAchievementArray indexOfObject:instance];
    [pastAchievementArray removeObjectAtIndex:findIndex];
}
-(void)deletePastAchievementInstanceAtIndex:(NSInteger)idx{
    [pastAchievementArray removeObjectAtIndex:idx];
}

//Past Failures
// ---- Delete
-(void)deleteFailedActivityInstanceIdenticalTo:(FailedActivityInstance*)instance{
    NSUInteger findIndex = [failedActivityArray indexOfObject:instance];
    [failedActivityArray removeObjectAtIndex:findIndex];
}
-(void)deleteFailedActivityInstanceAtIndex:(NSInteger)idx{
    [failedActivityArray removeObjectAtIndex:idx];
}

#pragma mark - File Manipulation
-(BOOL)dataExists{
    NSArray*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"data"];
    BOOL status = [[NSFileManager defaultManager]fileExistsAtPath:filePath];
    return status;
}

-(BOOL)saveToFile{
    //Load up the dictionary
    activitiesDictionary = @{kACTIVITY_DICTIONARY_NORMAL_LIST:normalListActivityArray,kACTIVITY_DICTIONARY_DAILY_ROUTINE:dailyListActivityArray,kACTIVITY_DICTIONARY_REDUNDANCY:redundantListActivityArray,kACTIVITY_DICTIONARY_ONGOING:ongoingActivityArray,kACTIVITY_DICTIONARY_ACHIEVEMENT:pastAchievementArray,kACTIVITY_DICTIONARY_FAIL:failedActivityArray};
    
    //Save it
    NSArray*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"data"];
    //Write to file
    BOOL status = [NSKeyedArchiver archiveRootObject:activitiesDictionary toFile:filePath];
    return status;
}

-(NSMutableDictionary*)loadFileToDictionary{
    NSArray*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"data"];
    //load
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    NSMutableDictionary *mutableDictionary;
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        mutableDictionary = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    }else{
        NSLog(@"No file saved");
    }
    return mutableDictionary;
}
#pragma mark - List Instance management 
//TODO: a lot......
-(void)addListActivity:(ActivityListInstance *)taskInstance{
    [normalListActivityArray addObject:taskInstance];
}

-(void)completeListActivityAtIndex:(NSInteger)index{
    [(ActivityListInstance*)[normalListActivityArray objectAtIndex:index] setCompleted:YES];
}

-(void)completeRedundantActivityAtIndex:(NSInteger)index{
    [(ActivityListInstance*)[redundantListActivityArray objectAtIndex:index] setCompleted:YES];
}

-(void)setToBeDailyActivityAtIndex:(NSInteger)index{
    //Set the instance to be daily
    [(ActivityListInstance*)[normalListActivityArray objectAtIndex:index] setTobeDailyRoutine:YES];
    //Move the instance to the daily array
    [dailyListActivityArray addObject:[normalListActivityArray objectAtIndex:index]];
    //Remove from the original
    [normalListActivityArray removeObjectAtIndex:index];
}

-(void)removeFromDailyActivitiesWithIndex:(NSInteger)index{
    //remove from daily
    [(ActivityListInstance*)[dailyListActivityArray objectAtIndex:index] setTobeDailyRoutine:NO];
    //Move the instance to the normal array
    [normalListActivityArray addObject:[normalListActivityArray objectAtIndex:index]];
    //Remove from the original
    [dailyListActivityArray removeObjectAtIndex:index];
}

-(void)setToBeRedundantTaskAtIndex:(NSInteger)index{
    //Set the instance to be redundant
    [(ActivityListInstance*)[normalListActivityArray objectAtIndex:index] setRedundancy:YES];
    //Move the instance to the redundant array
    [redundantListActivityArray addObject:[normalListActivityArray objectAtIndex:index]];
    //Remove from the original
    [normalListActivityArray removeObjectAtIndex:index];
}

-(void)summariseListActivities{
    //Clean up redundancies
    for (ActivityListInstance*instance in redundantListActivityArray) {
        if (instance.isCompleted) {
            [redundantListActivityArray removeObject:instance];
        }
    }
    //Clean up normal lists
    for (ActivityListInstance*instance in normalListActivityArray) {
        if (instance.isCompleted) {
            [normalListActivityArray removeObject:instance];
        }
    }
}

#pragma mark - Data Manipulation
-(NSDictionary*)constructTimeComponentsWithTimeInSecs:(long)secs{
    
    //Construct compoents
    NSInteger day = secs / 86400;
    NSInteger hour = (secs % 86400)/ 3600;
    NSInteger minute = ((secs % 86400) % 3600)/60;
    NSInteger second = ((secs % 86400) % 3600)%60;
    //Construct dictionary
    NSMutableDictionary* currentTimeDictionary = [[NSMutableDictionary alloc]init];
    [currentTimeDictionary setValue:[NSNumber numberWithInteger:day] forKey:@"day"];
    [currentTimeDictionary setValue:[NSNumber numberWithInteger:hour] forKey:@"hour"];
    [currentTimeDictionary setValue:[NSNumber numberWithInteger:minute] forKey:@"minute"];
    [currentTimeDictionary setValue:[NSNumber numberWithInteger:second] forKey:@"second"];
    return currentTimeDictionary;
    
}


#pragma mark - accessors
-(NSArray*)getOngoingActivityInArray{
    return ongoingActivityArray;
}
-(NSArray*)getPastAchievementsArray{
    return pastAchievementArray;
}
-(NSArray*)getFailedActivityArray{
    return failedActivityArray;
}
-(OngoingActivityInstance*)getOngoingInstance{
    if (ongoingActivityArray.count > 0) {
        return [ongoingActivityArray objectAtIndex:ongoingActivityArray.count-1];
    }
    return nil;
}

-(NSArray*)getNormalActivitiesArray{
    return normalListActivityArray;
}

-(NSArray*)getRedundantActivitiesArray{
    return redundantListActivityArray;
}

-(NSArray*)getDailyActivitiesArray{
    return dailyListActivityArray;
}


@end
