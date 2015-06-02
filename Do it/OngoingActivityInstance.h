//
//  OngoingActivityInstance.h
//  Do it
//
//  Created by Jackie Chung on 18/05/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OngoingActivityInstance : NSObject

@property(strong,nonatomic) NSString *activtyTitle;
@property(strong,nonatomic) NSString *activityDescription;
@property(nonatomic) long remainingSecs;

typedef NS_ENUM(NSUInteger, OngoingActivitySatusCode){
    ONGOINGSTATUS_AMPLE = 5,
    ONGOINGSTATUS_MEDIUM = 4,
    ONGOINGSTATUS_STRESS = 3,
    ONGOINGSTATUS_COMPLETED = 2,
    ONGOINGSTATUS_GAVEUP = 1,
    ONGOINGSTATUS_FAILED = 0
};
@property (nonatomic) OngoingActivitySatusCode statusCode;

@property(nonatomic) NSInteger delayedTimes;

//Constructor
+(instancetype)sharedOngoingActivityWithTitle:(NSString*)title mainDescription:(NSString*)mainDes remainingSecs:(long)secs;

-(instancetype)initWithTitle:(NSString*)title mainDescription:(NSString*)mainDes remainingSecs:(long)secs;
//Publics Methods
-(void)delayActivityFor:(long)secs;

@end
