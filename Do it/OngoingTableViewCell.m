//
//  OngoingTableViewCell.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/20.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "OngoingTableViewCell.h"
#import "ActivityTableViewCellController.h"
#import "Constants.h"
@interface OngoingTableViewCell(){
    //initial secs direct from data
    long secs;
    //Initial timer components
    NSDictionary *timeComponents;
   
}
@end

@implementation OngoingTableViewCell
@synthesize cellDataInstance = _cellDataInstance;

#pragma mark - Initialization

- (void)awakeFromNib {
    
    //TODO::Style elements
    [self styleElements];
    //Add observer for activating/deactivating focus mode
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activateFocusMode) name:kNOTIF_ACTIVATE_FOCUS_MODE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deactivateFocusMode) name:kNOTIF_DEACTIVATE_FOCUS_MODE object:nil];
}


#pragma mark - actions
//Complete
- (IBAction)completeTask:(id)sender {
   [[ActivtyInstancesManager sharedManager]convertToAchievementWithOngoingInstance:_cellDataInstance];
    //Post notif to update tableview so that achievement cell can be loaded
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_UPDATE_ACTIVITY_TABLE_VIEW object:nil];
    //Post notif to invalidate NSTimer so that failed activity won't shown up
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_ONGOING_ACTIVITY_COMPLETE_PRESSED object:nil];
}

//Delay (should I?)
-(void)delayActivityWithTime:(long)addedSecs{
    
    //Update instance property
    [_cellDataInstance delayActivityFor:addedSecs];
    
    //Reconstruct time (BETTER ACCOMPANYING WITH ANIMATION)
    secs = _cellDataInstance.remainingSecs;
    timeComponents = [[ActivtyInstancesManager sharedManager]constructTimeComponentsWithTimeInSecs:secs];
    self.timeLeftLabel.text = [ActivityTableViewCellController timeLeftLabelTextFromTimeComponents:timeComponents];
}

//End
-(void)endActivity{
    if (_cellDataInstance.remainingSecs < 1) {
        //update status
        _cellDataInstance.statusCode = ONGOINGSTATUS_FAILED;
        [[ActivtyInstancesManager sharedManager]convertToFailedActivityWithOngoingInstance:_cellDataInstance Giveup:NO];
        
    }else{
        //update status
        _cellDataInstance.statusCode = ONGOINGSTATUS_GAVEUP;
        [[ActivtyInstancesManager sharedManager]convertToFailedActivityWithOngoingInstance:_cellDataInstance Giveup:YES];
        
    }
}

#pragma mark - Notfification receivers
-(void)increaseIntensityWithCurrentStatus:(OngoingActivitySatusCode)statusCode{
    _cellDataInstance.statusCode = statusCode;
    //TODO:: Update cell color based on status code
}

-(void)activateFocusMode{
    //TODO::
    
}

-(void)deactivateFocusMode{
    //TODO::
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - UI methods
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

//Style elements
-(void)styleElements{
   
}




@end
