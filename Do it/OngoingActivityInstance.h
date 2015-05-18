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
@property(nonatomic) double remainingSecs;


//ample,medium,stress,completed,gave up
-(NSInteger)getStatusCode;

-(instancetype)initWithTitle:(NSString*)title mainDescription:(NSString*)mainDes remainingSecs:(double)secs;

@end
