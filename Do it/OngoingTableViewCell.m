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
        
    //Set count down timer
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reduceTime) userInfo:nil repeats:YES];
    
}

#pragma mark - Data manipulation methods
-(void)reduceTime{
    //update instance property
    _cellDataInstance.remainingSecs--;
    //Update cell property
    second--;
    if (second < 0) {
        minute --;
    }
    if (minute < 0) {
        hour --;
    }
    if (hour < 0) {
        day--;
    }
    if (day < 0) {
        self.timeLeftLabel.text = @"End!";
        //invalidate timer
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        //End activity
        [self endActivity];
    }
    self.timeLeftLabel.text =  [NSString stringWithFormat:@"%ld:%ld:%ld:%ld",day,hour,minute,second];
    
    //Intensify
    if (_cellDataInstance.remainingSecs <= 0.5 * secs) {
        if (_cellDataInstance.remainingSecs <=0.1 * secs) {
            [self increaseIntensityWithCurrentStatus:ONGOINGSTATUS_STRESS];
            //update status
            _cellDataInstance.statusCode = ONGOINGSTATUS_STRESS;
        }else{
            [self increaseIntensityWithCurrentStatus:ONGOINGSTATUS_MEDIUM];
            //update status
            _cellDataInstance.statusCode = ONGOINGSTATUS_MEDIUM;
        }
    }
}


#pragma mark - actions
//Complete
- (IBAction)completeTask:(id)sender {
   [[ActivtyInstancesManager sharedManager]convertToAchievementWithOngoingInstance:_cellDataInstance];
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
    //Set count down timer
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reduceTime) userInfo:nil repeats:YES];
    
}

//End
-(void)endActivity{
    if (_cellDataInstance.remainingSecs < 0) {
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

}


@end
