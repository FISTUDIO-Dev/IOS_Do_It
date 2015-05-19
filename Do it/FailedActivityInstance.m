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
-(instancetype)initWithFailedTitle:(NSString *)title Description:(NSString *)desc Date:(NSDate *)date exceededSecs:(long)secs{
    if (self = [super init]) {
        self.failedTitle = title;
        self.failedDescription = desc;
        self.failedDate = date;
        self.exceededSecs = secs;
        self.givenUp = NO;
    }
    return self;
}

-(instancetype)initWithFailedTitle:(NSString *)title Description:(NSString *)desc Date:(NSDate *)date gaveUp:(BOOL)givenup{
    if (self = [super init]) {
        self.failedTitle = title;
        self.failedDescription = desc;
        self.failedDate = date;
        self.givenUp = givenup;
        self.exceededSecs = 0;
    }
    return self;
}

#pragma mark - Private methods
-(NSString*)description{
    return [NSString stringWithFormat:@"This is a failed activty which has title %@, description %@ on date %@",self.failedTitle,self.failedDescription,self.failedDate];
}



@end
