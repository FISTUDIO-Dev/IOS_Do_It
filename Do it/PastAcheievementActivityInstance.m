//
//  PastAcheievementActivityInstance.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/19.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "PastAcheievementActivityInstance.h"
@interface PastAcheievementActivityInstance()


@end

@implementation PastAcheievementActivityInstance

#pragma mark - Constructor
-(instancetype)initWithFinishedTitle:(NSString *)title Description:(NSString *)desc finishedDate:(NSDate *)date remainingSecs:(long)secs delayTimes:(NSInteger)times{
    if (self = [super init]){
        self.finishedTitle = title;
        self.finishedDescription = desc;
        self.finishedDate = date;
        self.remainingSecs = secs;
        self.delayedTimes = times;
    }
    return self;
}

#pragma mark - Private methods
-(NSString*)description{
    return [NSString stringWithFormat:@"This is a past successful activity with title %@, description %@, finished on date %@", self.finishedTitle,self.finishedDescription,self.finishedDate];
}

-(NSUInteger)hash{
    return [self.finishedTitle hash]+[self.finishedDescription hash]+[self.finishedDate hash]+ self.remainingSecs + self.delayedTimes;
}



-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        if ([self hash] == [object hash]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end
