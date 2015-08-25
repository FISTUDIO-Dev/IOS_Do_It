//
//  ActivtyInstancesManager.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/19.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivtyInstancesManager.h"
#import "GlobalNoticeHandler.h"
#import "LocalNotificationHandler.h"
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

#pragma mark - List Instance management
//add a new list activity
-(void)addListActivity:(ActivityListInstance *)taskInstance{
    [normalListActivityArray addObject:taskInstance];
}

//complete normal list items
-(void)completeListActivityAtIndex:(NSInteger)index{
    [(ActivityListInstance*)[normalListActivityArray objectAtIndex:index] setCompleted:YES];
    //make this completed one is dumped to the end
    [normalListActivityArray insertObject:(ActivityListInstance*)[normalListActivityArray objectAtIndex:index] atIndex:normalListActivityArray.count-1];
    [normalListActivityArray removeObjectAtIndex:index];
}

//complete redundant tasks
-(void)completeRedundantActivityAtIndex:(NSInteger)index{
    [(ActivityListInstance*)[redundantListActivityArray objectAtIndex:index] setCompleted:YES];
}

//complete daily tasks
-(void)completeDailyActivityAtIndex:(NSInteger)index{
    [(ActivityListInstance*)[dailyListActivityArray objectAtIndex:index] setCompleted:YES];
    
}

//set as daily activity
-(void)setToBeDailyActivityAtIndex:(NSInteger)index{
    //Set the instance to be daily
    [(ActivityListInstance*)[normalListActivityArray objectAtIndex:index] setTobeDailyRoutine:YES];
    //Move the instance to the daily array
    [dailyListActivityArray addObject:[normalListActivityArray objectAtIndex:index]];
    //Remove from the original
    [normalListActivityArray removeObjectAtIndex:index];
}

//remove activity from being daily
-(void)removeFromDailyActivitiesWithIndex:(NSInteger)index{
    //remove from daily
    [(ActivityListInstance*)[dailyListActivityArray objectAtIndex:index] setTobeDailyRoutine:NO];
    //remove daily reminder if any
    [(ActivityListInstance*)[dailyListActivityArray objectAtIndex:index] setReminder:nil];
    //Move the instance to the top of normal array
    [normalListActivityArray insertObject:[normalListActivityArray objectAtIndex:index] atIndex:0];
    //Cancel the notification
    NSString* notificationID = [(ActivityListInstance*)[dailyListActivityArray objectAtIndex:index] getuid];
    [LocalNotificationHandler cancelLocalNotificationWithID:notificationID];
    //Remove from the original
    [dailyListActivityArray removeObjectAtIndex:index];
}

//set reminder for daily activity
-(void)setReminderForDailyActivityWithIndex:(NSInteger)index AndTime:(NSDate *)date{
    //Set the reminder date for selected list item
    [(ActivityListInstance*)[dailyListActivityArray objectAtIndex:index] setReminder:[NSDate dateWithTimeInterval:-1.0 sinceDate:date]];
    //Prepare some data
    NSString* notificationBody = [(ActivityListInstance*)[dailyListActivityArray objectAtIndex:index] taskContent];
    NSString* notificationID = [(ActivityListInstance*)[dailyListActivityArray objectAtIndex:index] getuid];
    //Set notification to be scheduled
    [LocalNotificationHandler pushLocalNotificationWithTitle:@"Daily activity warning!" Message:[NSString stringWithFormat:@"Your task [%@] is waiting for you! Come and Do It!",notificationBody] ScheduledAt:date Repeat:YES SoundName:UILocalNotificationDefaultSoundName ExtraData:@{kDAILY_NOTIFICATION_TO_BE_CANCELLED_KEY:notificationID}];
}

//set redundant
-(void)setToBeRedundantTaskAtIndex:(NSInteger)index{
    //Set the instance to be redundant
    [(ActivityListInstance*)[normalListActivityArray objectAtIndex:index] setRedundancy:YES];
    //Move the instance to the redundant array
    [redundantListActivityArray addObject:[normalListActivityArray objectAtIndex:index]];
    //Remove from the original
    [normalListActivityArray removeObjectAtIndex:index];
}

//summarise Activities for a day
// - clean old activties
// - reload daily, redundancies and normal arrays
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
        }else{
            //Set instance to be redundant
            [instance setRedundancy:YES];
            //increase redundant days
            [instance incrementRedundancy];
            //add instance to redundant array
            [redundantListActivityArray addObject:instance];
            //remove from normal list array
            [redundantListActivityArray removeObject:instance];
        }
    }
    //Fresh up daily lists
    for (ActivityListInstance* instance in dailyListActivityArray) {
        [instance refreshDailyCounter];
    }
}

//convert activty to task mode
-(void)convertListItem:(ActivityListInstance *)listActivity toTask:(OngoingActivityInstance *)ongoingTask WithSetTimeLimit:(long)secs{
    if ([ongoingActivityArray count]>0) {
        [GlobalNoticeHandler createInformationalAlertViewWithTitle:@"Oops! What a conflict!" Description:@"You already have a task going on! Please finish that one first." ButtonText:@"I Get It"];
    }else{
        static NSString* taskTitle = @"Task is Streaming";
        OngoingActivityInstance* newOngoing = [[OngoingActivityInstance alloc]initWithTitle:taskTitle mainDescription:listActivity.taskContent remainingSecs:secs];
        [self addOngoingActivity:newOngoing];
    }
    //Complete receiver shall be configured in cell
    
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
