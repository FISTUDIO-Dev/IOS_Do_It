//
//  EventManager.h
//  Do it
//
//  Created by Jackie Chung on 18/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailyItemInstance.h"
@import EventKit;


@interface EventManager : NSObject

@property (strong,nonatomic)EKEventStore* eventStore;


/**
 
 * @brief   Singeleton launch
 
 * @param   nil
 
 * @return  Self
 
 */
+(instancetype)sharedManager;

/**
 
 * @brief   Create a daily event with information provided by a daily item
 
 * @param   DailyItemInstance dailyItem
 
 * @return  Bool
 
 */
-(BOOL)createDailyEventAssignedByDailyListInstance:(DailyItemInstance*)dailyItem;

/**
 
 * @brief   Remove a daily event matched with information provided by a daily
 
 * @param   DailyItemInstance dailyItem
 
 * @return  Bool
 
 */
-(BOOL)removeDailyEventAssignedByDailyListInstance:(DailyItemInstance*)dailyItem;

@end
