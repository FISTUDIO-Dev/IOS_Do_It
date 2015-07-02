//
//  ActivityTableViewCellController.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/6/6.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivityTableViewCellController.h"

@implementation ActivityTableViewCellController


+(NSString*)timeLeftLabelTextFromTimeComponents:(NSDictionary *)timeComponents{
    
    NSInteger day = [(NSNumber *)[timeComponents valueForKey:@"day"] integerValue];
    NSInteger hour = [(NSNumber*)[timeComponents valueForKey:@"hour"] integerValue];
    NSInteger minute = [(NSNumber*)[timeComponents valueForKey:@"minute"] integerValue];
    NSInteger second = [(NSNumber*)[timeComponents valueForKey:@"second"] integerValue];
    //Construction
    if (day == 0) {
        if (hour == 0) {
            if (minute == 0) {
                if (second == 0) {
                    return [NSString stringWithFormat:@"00:0%ld",second];
                }else{
                    if (second < 10) {
                        return [NSString stringWithFormat:@"00:0%ld",second];
                    }
                    return [NSString stringWithFormat:@"00:%ld",second];
                }
            }else{
                if (minute < 10) {
                    if (second < 10) {
                        return [NSString stringWithFormat:@"0%ld:0%ld",minute,second];
                    }
                    return [NSString stringWithFormat:@"0%ld:%ld",minute,second];
                }
                return [NSString stringWithFormat:@"%ld:%ld",minute,second];
            }
        }else{
            return [NSString stringWithFormat:@"%ld:%ld:%ld",hour,minute,second];
        }
    }else{
        return [NSString stringWithFormat:@"%ld:%ld:%ld:%ld",day,hour,minute,second];
    }
    
    return @"No Time Records";
}

+(NSString*)formattedDateStringFromDate:(NSDate *)date{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar]components:NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger year = [dateComponents year];
    NSString* monthWithName = [[dateFormatter shortMonthSymbols]objectAtIndex:month-1];
    //Contruction
    NSString * dateString = [NSString stringWithFormat:@"%@ %ld,%ld",monthWithName,day,year];
    return dateString;
}

+(NSString*)remainingTimeTextFromTimeComponents:(NSDictionary *)timeComponents{
    //Extract data
    NSInteger day = [(NSNumber *)[timeComponents valueForKey:@"day"] integerValue];
    NSInteger hour = [(NSNumber*)[timeComponents valueForKey:@"hour"] integerValue];
    NSInteger minute = [(NSNumber*)[timeComponents valueForKey:@"minute"] integerValue];
    NSInteger second = [(NSNumber*)[timeComponents valueForKey:@"second"] integerValue];
    //Prefix
    NSString* remainingPrefix = @"Time left: ";
    //Construction
    if (day == 0) {
        if (hour == 0) {
            if (minute == 0) {
                if (second == 0) {
                    return @"Completed On Time.";
                }else{
                    return [NSString stringWithFormat:@"%@:%ld secs",remainingPrefix,second];
                }
            }else{
                return [NSString stringWithFormat:@"%@: %ld mins %ld secs",remainingPrefix,minute,second];
            }
        }else{
            return [NSString stringWithFormat:@"%@: %ld hours %ld mins %ld secs",remainingPrefix,hour,minute,second];
        }
    }else{
        return [NSString stringWithFormat:@"%@: %ld days %ld hours %ld mins %ld secs",remainingPrefix,day,hour,minute,second];
    }
    
    return @"No Time Records";
}


@end
