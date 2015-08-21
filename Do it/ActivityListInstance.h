//
//  ActivityListInstance.h
//  Do it
//
//  Created by YINGGUANG CHEN on 15/8/17.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityListInstance : NSObject

@property (strong,nonatomic) NSString* taskContent;
@property (strong,nonatomic) NSDate* createdDate;
//Initialize
-(id)initListTaskWithContent:(NSString*)value;

//Getters and Setters
-(BOOL)isCompleted;
-(void)setCompleted:(BOOL)value;
-(BOOL)isRedundant;
-(void)setRedundancy:(BOOL)value;
-(BOOL)isDailyRoutine;
-(void)setTobeDailyRoutine:(BOOL)value;
-(void)setReminder:(NSDate*)date;
-(NSDate*)getReminderDate;
-(NSString*)getuid;
@end
