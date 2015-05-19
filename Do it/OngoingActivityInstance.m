//
//  OngoingActivityInstance.m
//  Do it
//
//  Created by Jackie Chung on 18/05/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "OngoingActivityInstance.h"

@interface OngoingActivityInstance()


@end


@implementation OngoingActivityInstance

#pragma mark - Constructors
+(instancetype)sharedOngoingActivityWithTitle:(NSString *)title mainDescription:(NSString *)mainDes remainingSecs:(long)secs{
    static OngoingActivityInstance* myInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void){
        myInstance = [[self alloc]initWithTitle:title mainDescription:mainDes remainingSecs:secs];
    });
    return myInstance;
}

-(instancetype)initWithTitle:(NSString *)title mainDescription:(NSString *)mainDes remainingSecs:(long)secs{
    if (self = [super init]) {
        //Visibles
        self.activtyTitle = title;
        self.activityDescription = mainDes;
        self.remainingSecs = secs;
        //Non-visibles
        self.statusCode = ONGOINGSTATUS_AMPLE;
    }
    return self;
}

#pragma mark - Public methods
-(void)delayActivityFor:(long)secs{
    //Add secs
    self.remainingSecs += secs;
    //Increase delayed times
    self.delayedTimes ++;
}

#pragma mark - Private methods
-(NSString*)description{
    return [NSString stringWithFormat:@"Ongoing activty with title %@, description %@ and remaining seconds %ld",self.activtyTitle,self.activityDescription,self.remainingSecs];
}




@end
