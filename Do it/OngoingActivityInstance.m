//
//  OngoingActivityInstance.m
//  Do it
//
//  Created by Jackie Chung on 18/05/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "OngoingActivityInstance.h"
#import "GlobalNoticeHandler.h"
#import "Constants.h"

@interface OngoingActivityInstance(){
    BOOL isFocusing;
}
@end

@implementation OngoingActivityInstance

#pragma mark - Constructors

-(instancetype)initWithTitle:(NSString *)title mainDescription:(NSString *)mainDes remainingSecs:(long)secs{
    if (self = [super init]) {
        //Visibles
        self.activtyTitle = title;
        self.activityDescription = mainDes;
        self.remainingSecs = secs;
        //Non-visibles
        self.statusCode = ONGOINGSTATUS_AMPLE;
        self.initialTime = secs;
        isFocusing = NO;
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

-(void)setFocused:(BOOL)isFocused{
    isFocusing = isFocused;
    if (isFocusing) {
        [self activateFocusMode];
    }else{
        [self deactviateFocusMode];
    }
}

-(BOOL)getFocus{
    return isFocusing;
}
-(NSString*)description{
    return [NSString stringWithFormat:@"Ongoing activty with title %@, description %@ and remaining seconds %ld",self.activtyTitle,self.activityDescription,self.remainingSecs];
}

#pragma mark - Private methods
-(void)activateFocusMode{
    //Post notfication to TableViewCell to apply UIChanges
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_ACTIVATE_FOCUS_MODE object:nil];
}
-(void)deactviateFocusMode{
    //Post notification to TableViewCell to apply UIChanges
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_DEACTIVATE_FOCUS_MODE object:nil];
}



@end
