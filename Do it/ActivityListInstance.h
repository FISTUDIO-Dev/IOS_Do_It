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

//Initialize
-(id)initListTaskWithContent:(NSString*)value;

//Getters and Setters
-(BOOL)isRedundant;
-(void)setRedundancy:(BOOL)value;
-(BOOL)isDailyRoutine;
-(void)setTobeDailyRoutine:(BOOL)value;
@end
