//
//  OngoingTableViewCell.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/20.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "OngoingTableViewCell.h"
#import "ActivityTableViewCellController.h"
@interface OngoingTableViewCell(){
    //initial secs direct from data
    long secs;
    //Initial timer components
    NSDictionary *timeComponents;
    //timer components separated
    NSInteger day, hour, minute, second;
   
}
@property(strong,nonatomic)NSTimer * countDownTimer;
@end

@implementation OngoingTableViewCell
@synthesize cellDataInstance = _cellDataInstance;

#pragma mark - Initialization

- (void)awakeFromNib {
    // Initialization code
    
    //TODO::Style elements
    [self styleElements];
    
}


#pragma mark - actions
//Complete
- (IBAction)completeTask:(id)sender {
   [[ActivtyInstancesManager sharedManager]convertToAchievementWithOngoingInstance:_cellDataInstance];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notif_updateTableViewData" object:nil];
}

//Delay (should I?)
-(void)delayActivityWithTime:(long)addedSecs{
    
    //Update instance property
    [[OngoingActivityInstance sharedOngoingActivityWithTitle:_cellDataInstance.activtyTitle mainDescription:_cellDataInstance.activityDescription remainingSecs:_cellDataInstance.remainingSecs]delayActivityFor:addedSecs];
    
    //invalidate timer
    [self.countDownTimer invalidate];
    
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
    //TODO:: Update cell color based on status code
}

-(void)dealloc{
    
}

#pragma mark - UI methods
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

//Style elements
-(void)styleElements{
    CGRect ongoingLabelFrame = self.ongoingTitleLabel.frame;
    [self.ongoingTitleLabel setFrame:CGRectMake(ongoingLabelFrame.origin.x, ongoingLabelFrame.origin.y, 200, ongoingLabelFrame.size.height)];
    NSLog(@"%f",ongoingLabelFrame.size.width);
}


@end
