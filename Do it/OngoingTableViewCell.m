//
//  OngoingTableViewCell.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/20.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "OngoingTableViewCell.h"
@interface OngoingTableViewCell(){
    //secs direct from data
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
@synthesize manager = _manager;

#pragma mark - Initialization
- (void)awakeFromNib {
    // Initialization code
    if (self.cellDataInstance) {
        //TODO::Style elements
        [self styleElements];
        
        //Set up data
        self.ongoingTitleLabel.text = _cellDataInstance.activtyTitle;
        self.ongoingDescriptionLabel.text = _cellDataInstance.activityDescription;
        secs = _cellDataInstance.remainingSecs;
        
        //Initialize Timer components
        timeComponents = [[ActivtyInstancesManager sharedManager]constructTimeComponentsWithTimeInSecs:secs];
        self.timeLeftLabel.text = [self timeLeftLabelTextFromTimeComponents];
        //Set count down timer
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reduceTime) userInfo:nil repeats:YES];
    }
}

#pragma mark - Data manipulation methods
-(NSString*)timeLeftLabelTextFromTimeComponents{
    NSString * time;
    if (timeComponents) {
        time = [[NSString alloc]init];
        //Extract contents
        day = [(NSNumber *)[timeComponents valueForKey:@"day"] integerValue];
        hour = [(NSNumber*)[timeComponents valueForKey:@"hour"] integerValue];
        minute = [(NSNumber*)[timeComponents valueForKey:@"minute"] integerValue];
        second = [(NSNumber*)[timeComponents valueForKey:@"second"] integerValue];
        //Construction
        if (day == 0) {
            if (hour == 0) {
                if (minute == 0) {
                    if (second == 0) {
                        return @"empty";
                    }else{
                        return [NSString stringWithFormat:@"%ld",second];

                    }
                }else{
                    return [NSString stringWithFormat:@"%ld:%ld",minute,second];
                }
            }else{
                return [NSString stringWithFormat:@"%ld:%ld:%ld",hour,minute,second];
            }
        }else{
            return [NSString stringWithFormat:@"%ld:%ld:%ld:%ld",day,hour,minute,second];
        }
    }
    
    return time;
}

-(void)reduceTime{
    //update instance property
    _cellDataInstance.remainingSecs--;
    
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
    }
    self.timeLeftLabel.text =  [NSString stringWithFormat:@"%ld:%ld:%ld:%ld",day,hour,minute,second];
}


#pragma mark - actions
//Complete button action
- (IBAction)completeTask:(id)sender {
   [[ActivtyInstancesManager sharedManager]convertToAchievementWithOngoingInstance:_cellDataInstance];
}

//Delay
-(void)delayActivityWithTime:(long)addedSecs{
    
    //Update instance property
    [[OngoingActivityInstance sharedOngoingActivityWithTitle:_cellDataInstance.activtyTitle mainDescription:_cellDataInstance.activityDescription remainingSecs:_cellDataInstance.remainingSecs]delayActivityFor:addedSecs];
    
    //invalidate timer
    [self.countDownTimer invalidate];
    
    //Reconstruct time (BETTER ACCOMPANYING WITH ANIMATION)
    secs = _cellDataInstance.remainingSecs;
    timeComponents = [[ActivtyInstancesManager sharedManager]constructTimeComponentsWithTimeInSecs:secs];
    self.timeLeftLabel.text = [self timeLeftLabelTextFromTimeComponents];
    //Set count down timer
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reduceTime) userInfo:nil repeats:YES];
    
}



-(void)endActivity{
    if (_cellDataInstance.remainingSecs < 0) {
        [[ActivtyInstancesManager sharedManager]convertToFailedActivityWithOngoingInstance:_cellDataInstance Giveup:NO];
    }else{
        [[ActivtyInstancesManager sharedManager]convertToFailedActivityWithOngoingInstance:_cellDataInstance Giveup:YES];
    }
}

#pragma mark - UI methods
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

//Style elements
-(void)styleElements{

}


@end
