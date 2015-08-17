//
//  ActivityListInstance.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/8/17.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivityListInstance.h"
@interface ActivityListInstance(){}
@property (assign,nonatomic) BOOL isRedundant;
@property (assign,nonatomic) BOOL isDaily;
@end

@implementation ActivityListInstance

#pragma mark - Initialize
-(id)init{
    [NSException raise:@"Use designated initialize" format:@"Initialize with task content"];
    return nil;
}

-(id)initListTaskWithContent:(NSString *)value{
    self = [super init];
    if (self) {
        _taskContent = value;
        self.isRedundant = NO;
        self.isDaily = NO;
    }
    return self;
}

#pragma mark - Getters and Setters
-(BOOL)isRedundant{
    return self.isRedundant;
}
-(void)setRedundancy:(BOOL)value{
    self.isRedundant = value;
}
-(BOOL)isDailyRoutine{
    return self.isDaily;
}
-(void)setTobeDailyRoutine:(BOOL)value{
    self.isDaily = value;
}
@end
