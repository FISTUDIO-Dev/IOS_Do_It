//
//  ActivtyInstancesManager.h
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/19.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OngoingActivityInstance.h"
#import "PastAcheievementActivityInstance.h"
#import "FailedActivityInstance.h"

@interface ActivtyInstancesManager : NSObject

+(id)sharedManager;
-(instancetype)init;

@end
