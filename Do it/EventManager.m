//
//  EventManager.m
//  Do it
//
//  Created by Jackie Chung on 18/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "EventManager.h"

@implementation EventManager{
    
    BOOL permissionGranted;
    
}


+(instancetype)sharedManager{
    
    static EventManager* manager = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^(void){
        
        manager = [[self alloc]init];
        
    });
    
    return manager;
    
}


-(instancetype)init{
    
    if (self = [super init]) {
        
        _eventStore = [[EKEventStore alloc]init];
        
        [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError* error){
           
            permissionGranted = granted;
            
        }];
        
    }
    
    return self;
    
}

-(BOOL)createDailyEventAssignedByDailyListInstance:(DailyItemInstance *)dailyItem{
    
    EKEvent* newDailyEvent = [[EKEvent alloc]init];
    
    EKRecurrenceRule* newRecurrentRule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:NULL];
    
    [newDailyEvent addRecurrenceRule:newRecurrentRule];
    
    newDailyEvent.title = dailyItem.content;
    
    newDailyEvent.startDate = [NSDate date];
    
    newDailyEvent.endDate = [NSDate dateWithTimeInterval:INFINITY sinceDate:[NSDate date]];
    
    [newDailyEvent addAlarm:[EKAlarm alarmWithAbsoluteDate:[dailyItem getCreationDate]]];
    
    NSError* error;
    
    if ([_eventStore saveEvent:newDailyEvent span:EKSpanFutureEvents commit:YES error:&error]) {
        
        dailyItem.optionalEventIdentifier = [newDailyEvent eventIdentifier];
        
        return YES;
        
    }
    
    NSLog(@"Saving event error:%@",[error localizedDescription]);
    
    return NO;
    
}

-(BOOL)removeDailyEventAssignedByDailyListInstance:(DailyItemInstance *)dailyItem{
    
    EKEvent* theEvent = [_eventStore eventWithIdentifier:dailyItem.optionalEventIdentifier  ];
    
    NSError* error;
    
    if ([_eventStore removeEvent:theEvent span:EKSpanFutureEvents error:&error]) {
        
        dailyItem.optionalEventIdentifier = @"";
        
        return YES;
        
    }
    
    NSLog(@"Deleting event error:%@",[error localizedDescription]);
    
    return NO;
}

@end
