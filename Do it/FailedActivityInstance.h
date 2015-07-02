//
//  FailedActivityInstance.h
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/19.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FailedActivityInstance : NSObject

@property (strong,nonatomic) NSString* failedTitle;
@property (strong,nonatomic) NSString* failedDescription;
@property (strong,nonatomic) NSDate* failedDate;
@property (nonatomic) long trialTime;
@property (nonatomic) BOOL givenUp;

-(instancetype)initWithFailedTitle:(NSString *)title Description:(NSString *)desc Date:(NSDate *)date TrialTime:(long)secs gaveUp:(BOOL)givenup;

-(NSUInteger)hash;
-(BOOL)isEqual:(id)object;
@end
