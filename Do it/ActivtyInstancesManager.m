//
//  ActivtyInstancesManager.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/19.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivtyInstancesManager.h"
#import "GlobalNoticeHandler.h"
@interface ActivtyInstancesManager(){
    NSMutableArray* activitiesArray;
    NSMutableArray* ongoingActivityArray;
    NSMutableArray* pastAchievementArray;
    NSMutableArray* failedActivityArray;
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
            activitiesArray = [self loadFileToArray];
        }else{
            ongoingActivityArray = [[NSMutableArray alloc]init];
            pastAchievementArray = [[NSMutableArray alloc]init];
            failedActivityArray  = [[NSMutableArray alloc]init];
            [activitiesArray addObject:ongoingActivityArray];
            [activitiesArray addObject:pastAchievementArray];
            [activitiesArray addObject:failedActivityArray];
        }
    }
    return self;
}

#pragma mark - Instance Managements
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
    if (ongoingActivityArray.count ==0) {
        [ongoingActivityArray addObject:newInstance];
    }else{
        [GlobalNoticeHandler createInformationalAlertViewWithTitle:@"Oops" Description:@"Hey ! You have an ongoing task ! Please do it first!" ButtonText:@"I Get It"];
    }
}

//Ongoing activity
//---- Add
-(void)addOngoingActivity:(OngoingActivityInstance*)activity{
    if (ongoingActivityArray.count > 0) {
        [ongoingActivityArray removeLastObject];
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
    NSArray*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"data"];
    //Write to file
    BOOL status = [NSKeyedArchiver archiveRootObject:activitiesArray toFile:filePath];
    return status;
}

-(NSMutableArray*)loadFileToArray{
    NSArray*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"data"];
    //load
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }else{
        NSLog(@"No file saved");
    }
    return array;
}

#pragma mark - UI Manipulation
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
- (NSArray*)getAllActivities{
    return activitiesArray;
}
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

@end
