//
//  FailedActivityInstance.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/19.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "FailedActivityInstance.h"

@interface FailedActivityInstance()

@end

@implementation FailedActivityInstance

#pragma mark - Constructors

-(instancetype)initWithFailedTitle:(NSString *)title Description:(NSString *)desc Date:(NSDate *)date TrialTime:(long)secs gaveUp:(BOOL)givenup{
    if (self = [super init]) {
        self.failedTitle = title;
        self.failedDescription = desc;
        self.failedDate = date;
        self.trialTime = secs;
        self.givenUp = givenup;
    }
    return self;
}

#pragma mark - Private methods
-(NSString*)description{
    return [NSString stringWithFormat:@"This is a failed activty which has title %@, description %@ on date %@",self.failedTitle,self.failedDescription,self.failedDate];
}

-(NSUInteger)hash{
    return [self.failedTitle hash]+[self.failedDescription hash]+[self.failedDate hash];
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
