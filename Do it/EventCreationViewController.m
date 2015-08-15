//
//  EventCreationViewController.m
//  Do it
//
//  Created by Jackie Chung on 16/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "EventCreationViewController.h"
#import "UIView+MaterialDesign.h"
#import "UIColor+flat.h"
#import "FeRippleButton.h"
#import "OngoingActivityInstance.h"
#import "ActivtyInstancesManager.h"
#import "Constants.h"
@interface EventCreationViewController (){
    FeRippleButton*proceedBtn;
    NSArray * viewArray;
    NSInteger currentViewIndex;
    
    //Construction output
    OngoingActivityInstance * constructingInstance;
}

@end

@implementation EventCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    constructingInstance = [[OngoingActivityInstance alloc]init];
    [self setUpViews];
    //add observers
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(introProcReceived:) name:kNOTIF_EC_INTRO_VIEW_PROCEEDING object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(introCancReceived) name:kNOTIF_EC_INTRO_VIEW_CANCELLING object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(taskViewProcReceived:) name:kNOTIF_EC_TASK_VIEW_PROCEEDING object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timePickerProcReceived:) name:kNOTIF_EC_TIME_PICKER_PROCEEDING object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finalViewFinishReceived:) name:kNOTIF_EC_FINAL_FINISH object:nil];
}

#pragma mark Notification receivers and action triggers

-(void)introProcReceived:(NSNotification*)notification{
    CGPoint touchPoint = [(NSValue*)[[notification userInfo]objectForKey:@"touch_loc"] CGPointValue];
    [UIView mdInflateTransitionFromView:_introView toView:_taskView originalPoint:touchPoint duration:0.65 completion:nil];
}

-(void)introCancReceived{
    //Dismiss
    [self triggerDelegateDismissVCWithData:NO];
}

-(void)taskViewProcReceived:(NSNotification*)notification{
    CGPoint touchPoint = [(NSValue*)[[notification userInfo]objectForKey:@"touch_loc"] CGPointValue];
    NSString* taskTitle = [[notification userInfo]objectForKey:@"task_title"];
    NSString* taskDescription = [[notification userInfo]objectForKey:@"task_desc"];
    BOOL isFocused = [(NSNumber*)[[notification userInfo]objectForKey:@"focused"] boolValue];
    //Set data property
    [self setDataWithTitle:taskTitle Description:taskDescription isFocused:isFocused];
    //Push to new view
    [UIView mdInflateTransitionFromView:_taskView toView:_pickerView originalPoint:touchPoint duration:0.65 completion:nil];
}

-(void)timePickerProcReceived:(NSNotification*)notification{
    //Get data
    CGPoint touchPoint = [(NSValue*)[[notification userInfo]objectForKey:@"touch_loc"] CGPointValue];
    long time = [(NSNumber*)[[notification userInfo]objectForKey:@"time"] longValue];
    //Set data property
    [self setDataWithTimeRemainingSeconds:time];
    //Push to new view
    [UIView mdInflateTransitionFromView:_pickerView toView:_finalView originalPoint:touchPoint duration:0.65 completion:nil];
    
}

-(void)finalViewFinishReceived:(NSNotification*)notification{
    CGPoint touchPoint = [(NSValue*)[[notification userInfo]objectForKey:@"touch_loc"] CGPointValue];
    
    UIView* nilView = [[UIView alloc]initWithFrame:self.view.frame];
    nilView.backgroundColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:1.0 animations:^(void){
        [self.view setAlpha:0.0];
    }];
    
    [UIView mdDeflateTransitionFromView:_finalView toView:nilView originalPoint:touchPoint duration:0.65 completion:^(void){
        [self triggerDelegateDismissVCWithData:YES];
    }];

}
#pragma mark - Set up UI Elements
-(void)setUpViews{
    CGRect frame = CGRectMake(2.0, 2.0, self.view.frame.size.width-4, self.view.frame.size.height-4);
    
    _introView = [[IntroView alloc]initWithFrame:frame];
    _taskView = [[TaskCreation alloc]initWithFrame:frame];
    _pickerView = [[TimePickerView alloc]initWithFrame:frame];
    _finalView = [[FinalizingTaskView alloc]initWithFrame:frame];
    
    // more to come...
    viewArray = @[_introView,_taskView,_pickerView,_finalView];
    // add first view to the controller
    [self.view addSubview:_introView];
    
}


#pragma mark - Private Functions
// ========== Data contruction
-(void)setDataWithTitle:(NSString*)title Description:(NSString*)desc isFocused:(BOOL)focused{
    constructingInstance.activtyTitle = title;
    constructingInstance.activityDescription = desc;
    [constructingInstance setFocused:focused];
}

-(void)setDataWithTimeRemainingSeconds:(long)secs{
    constructingInstance.initialTime = secs;
    constructingInstance.remainingSecs = secs;
}

-(void)addDataInstance{
    [[ActivtyInstancesManager sharedManager]addOngoingActivity:constructingInstance];
}

// ========== Dismiss VC
-(void)triggerDelegateDismissVCWithData:(BOOL)haveData{
    if ([_delegate respondsToSelector:@selector(dismissEventCreationViewControllerWithData:)]) {
        if (haveData) {
            [self addDataInstance];
            [_delegate dismissEventCreationViewControllerWithData:YES];
        }else{
            [_delegate dismissEventCreationViewControllerWithData:NO];
        }
    }
}

#pragma mark - Defaults

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    constructingInstance = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
