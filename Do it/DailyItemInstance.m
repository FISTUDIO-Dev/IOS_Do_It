//
//  DailyItemInstance.m
//  Do it
//
//  Created by Jackie Chung on 18/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DailyItemInstance.h"

@implementation DailyItemInstance{
    
    NSDate* createdAt;
    
    NSInteger* completedDays;
    
}


-(instancetype)init{
    
    [NSException raise:@"Use designated initializer" format:@"Initialize with custom attributes"];
    
    return nil;
    
}


-(instancetype)initWithContent:(NSString *)content Reminder:(NSDateComponents *)reminderDate{
    
    if (self = [super init]) {
        
        self.content = content;
        
        self.reminderDate = reminderDate;
        
        self.completionRate = 0;
        
        self.optionalEventIdentifier = @"";
        
        createdAt = [NSDate date];
        
    }
    
    return self;
    
}

-(NSInteger)daysOfCreation {
    
    return [[NSDate date] timeIntervalSinceDate:createdAt] / 86400 ;
    
}

-(void)complete {
    
    completedDays ++ ;
    
}

-(NSDate*)getCreationDate{
    
    return [createdAt copy];
    
}



-(NSString*)description {
    
    return [NSString stringWithFormat:@"Daily item with content %@",self.content];
    
}
@end
