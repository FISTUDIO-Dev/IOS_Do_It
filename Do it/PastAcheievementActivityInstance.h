//
//  PastAcheievementActivityInstance.h
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/19.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PastAcheievementActivityInstance : NSObject

@property (strong,nonatomic) NSString* finishedTitle;
@property (strong,nonatomic) NSString* finishedDescription;
@property (strong,nonatomic) NSDate* finishedDate;
@property (nonatomic) long remainingSecs;
@property (nonatomic) NSInteger delayedTimes;

-(instancetype)initWithFinishedTitle:(NSString*)title Description:(NSString*)desc finishedDate:(NSDate*)date remainingSecs:(long)secs delayTimes:(NSInteger)times;

-(BOOL)isEqual:(id)object;

-(NSUInteger)hash;
@end
