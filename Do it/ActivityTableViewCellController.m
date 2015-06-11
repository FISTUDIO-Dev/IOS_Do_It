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
                    return @"End!";
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
    
    return @"";
}

+(NSString*)formattedDateStringFromDate:(NSDate *)date{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
}

@end
