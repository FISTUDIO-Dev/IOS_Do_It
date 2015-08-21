//
//  ActivitiesTableViewController.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/29.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivitiesTableViewController.h"
#import "OngoingTableViewCell.h"
#import "AchievedActivityTableViewCell.h"
#import "FailedActivityTableViewCell.h"
#import "ActivityTableViewCellController.h"
#import "MGSwipeButton.h"
#import "DelayTimeSelectionViewController.h"
#import "DelayTimeViewControllerDelegate.h"
#import "EventCreationViewController.h"
#import "EventCreationDelegate.h"
#import "TimePickerViewController.h"
#import "TimePickerViewControllerDelegate.h"
#import "GlobalNoticeHandler.h"
#import "LocalNotificationHandler.h"
#import "Constants.h"
@interface ActivitiesTableViewController ()<delayViewControllerDelegate,EventCreationDelegate,TimePickerViewControllerDelegate,UIActionSheetDelegate>{
    //Ongoings
    OngoingActivityInstance * ongoingInstance;
    OngoingTableViewCell * ongoingCell;
    //Ongoing focus mode enabled?
    BOOL ongoingFocused;
    //Temporary Failed Instance for Retrial
    FailedActivityInstance* tempFailedInstance;
    //Save date for comparison when enter background
    NSDate* previousDateOfEnteringBG;
    
}

@end

@implementation ActivitiesTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Test instance
    ongoingInstance = [[OngoingActivityInstance alloc]initWithTitle:@"test for spesh" mainDescription:@"This time focus on speed" remainingSecs:20];
    [ongoingInstance setFocused:YES];
    [[ActivtyInstancesManager sharedManager]addOngoingActivity:ongoingInstance];
    
    //Use blur for popup
    self.useBlurForPopup = YES;
    
    //Add observer for update tableview
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableView) name:kNOTIF_UPDATE_ACTIVITY_TABLE_VIEW object:nil];
    //Add observer for present actionsheet
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentNewTimeSelectionSheet:) name:kNOTIF_PRESENT_RETRY_TIME_SELECTION_ACTION_SHEET object:nil];
    //Add observer for complete button pressed
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(completeButtonPressed) name:kNOTIF_ONGOING_ACTIVITY_COMPLETE_PRESSED object:nil];
    
    //Add observer for entering background
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //Add observer for reentering foreground
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundResume) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //Check if ongoing exits
    BOOL ongoingExists = ([[ActivtyInstancesManager sharedManager]getOngoingActivityInArray].count > 0)?YES:NO;
    //If !exist -> create a new one
    if (!ongoingExists) {
        [self presentEventCreationViewController];
    }else{
        [self loadOngoingInstance];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTableView{
    [self.tableView reloadData];
}

- (void)updateTableViewCellAtSection:(NSInteger)section Row:(NSInteger)row{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadOngoingInstance{
    //Get instance
    ongoingInstance = [[ActivtyInstancesManager sharedManager]getOngoingInstance];
    //Check if it's focused
    ongoingFocused = [ongoingInstance getFocus];
    //Update tableview
    [self updateTableView];
    //Initialize timer
    [self initialize];
    
}

-(void)completeButtonPressed{
    //End timer
    [self stop];
    //Push success message
    [GlobalNoticeHandler showIndicativeAlertWithTitle:@"Fantastic! You DID IT!" Subtitle:@"Congratulations on you success! You can now show to your friends you've done this:)" Closebuttontitle:@"Great!" AlertType:DIALERT_SUCCESS Duration:INFINITY];
}

// NSTimer Controls
// Generic Pause
-(void)stop{
    [_ongoingTimer invalidate];
    _ongoingTimer = nil;
}

// Generic resume
-(void)resume{
    if (_ongoingTimer == nil) {
        _ongoingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateOngoingCellText) userInfo:nil repeats:YES];
    }
}

//Action after entering background
-(void)backgroundPause{
    if (!ongoingFocused) {
        //Push notification
        [LocalNotificationHandler pushLocalNotificationWithTitle:@"You left the task!" Message:@"Having an emergency? Don't worry, the task timer is paused for you! Get back quickly!" ScheduledAt:[NSDate date] Repeat:NO SoundName:nil ExtraData:nil];
        //Invalidate timer
        [self stop];
    }else{
        //Push a notification to warn user that the focus mode is enabled
        [LocalNotificationHandler pushLocalNotificationWithTitle:@"Warning! Focus mode enabled!" Message:@"Uh hur? You seems to be distracted! The task will fail if you leave the app for more than ten seconds! Tap me to go back to task quickly!" ScheduledAt:[NSDate date] Repeat:YES SoundName:nil ExtraData:nil];
        //Meanwhile save the current time for later comparison
        previousDateOfEnteringBG = [NSDate date];
    }
}

//Action after resuming from backgroud
-(void)backgroundResume{
    if (!ongoingFocused) {
        if (_ongoingTimer == nil) {
            _ongoingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateOngoingCellText) userInfo:nil repeats:YES];
        }
    }else{
        NSDate* currentDateOfEnteringFG = [NSDate date];
        if ([currentDateOfEnteringFG timeIntervalSinceDate:previousDateOfEnteringBG] >= 10.0) {
            //Let user know
            [GlobalNoticeHandler showHUDWithText:@"Oops! You have been distracted for too long! The task is now failed. Please try again later!" ForPeriod:1.5 Success:NO Interactive:NO Callback:nil];
            //End the task
            [ongoingCell endActivity];
            //Stop timer
            [self stop];
            //Update tableview
            [self updateTableView];
        }else{
            [self resume];
        }
    }
    
}

-(void)initialize{
    _ongoingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateOngoingCellText) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.ongoingTimer forMode:NSRunLoopCommonModes];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTIF_UPDATE_ACTIVITY_TABLE_VIEW object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTIF_PRESENT_RETRY_TIME_SELECTION_ACTION_SHEET object:nil ];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTIF_ONGOING_ACTIVITY_COMPLETE_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [[ActivtyInstancesManager sharedManager]getOngoingActivityInArray].count;
    }
    if (section == 1) {
        return [[ActivtyInstancesManager sharedManager] getPastAchievementsArray].count;
    }
    if (section == 2) {
        return [[ActivtyInstancesManager sharedManager] getFailedActivityArray].count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            //Create
            ongoingCell = (OngoingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OngoingCell"];
            
            if(ongoingCell == nil){
                ongoingCell = [[[NSBundle mainBundle]loadNibNamed:@"OngoingTableViewCell" owner:self options:nil]objectAtIndex:0];
            }
            ongoingCell.delegate = self;
            [self initializeOngoingCell:ongoingCell WithOngoingInstance:ongoingInstance];
            
            return ongoingCell;
    
        }
            break;
        case 1:{
            //Create
            AchievedActivityTableViewCell * achievementCell = (AchievedActivityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"achievementCell"];
            if (achievementCell == nil) {
                achievementCell = [[[NSBundle mainBundle]loadNibNamed:@"AchievedActivityTableViewCell" owner:self options:nil]objectAtIndex:0];
            }
            achievementCell.delegate = self;
            PastAcheievementActivityInstance* instance = [[[ActivtyInstancesManager sharedManager]getPastAchievementsArray]objectAtIndex:indexPath.row];
            [self initializeAchievementCell:achievementCell WithAchievementInstance:instance];
            
            return achievementCell;
        }
            break;
        case 2:{
            //Create
            FailedActivityTableViewCell * failedCell = (FailedActivityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"failedCell"];
            if (failedCell == nil) {
                failedCell = [[[NSBundle mainBundle]loadNibNamed:@"FailedActivityTableViewCell" owner:self options:nil]objectAtIndex:0];
            }
            failedCell.delegate = self;
            FailedActivityInstance* instance = [[[ActivtyInstancesManager sharedManager]getFailedActivityArray]objectAtIndex:indexPath.row];
            [self initializeFailedActivityCell:failedCell WithFailedInstance:instance];
            
            return failedCell;
        }
        default:
            break;
    }
    return nil;
    
}


#pragma mark - Cell Controller - Ongoing Cell
//Setup view for Ongoing Cell
//@prama dataInstance
//@return OngoingTableviewCell
-(void)initializeOngoingCell:(OngoingTableViewCell*)cell WithOngoingInstance:(OngoingActivityInstance*)dataInstance{
    //Set up data
    cell.cellDataInstance = dataInstance;
    [cell.ongoingTitleLabel setText:cell.cellDataInstance.activtyTitle ];
    [cell.ongoingDescriptionLabel setText:cell.cellDataInstance.activityDescription];
    [cell.timeLeftLabel setText:[ActivityTableViewCellController timeLeftLabelTextFromTimeComponents:[[ActivtyInstancesManager sharedManager]constructTimeComponentsWithTimeInSecs:cell.cellDataInstance.remainingSecs]]];
    //Set status
    cell.cellDataInstance.statusCode = ONGOINGSTATUS_AMPLE;
}

//Initialize count down timer for ongoing cell
//@prama None
//@void
-(void)updateOngoingCellText{
    //Reduce for a second
    long currentRemainingSeconds = ongoingCell.cellDataInstance.remainingSecs;
    
    if (currentRemainingSeconds >0 ) {
        //Reduce second by one
        ongoingCell.cellDataInstance.remainingSecs--;
        
        //Update text from ongoing instance
        [ongoingCell.timeLeftLabel setText:[ActivityTableViewCellController timeLeftLabelTextFromTimeComponents:[[ActivtyInstancesManager sharedManager]constructTimeComponentsWithTimeInSecs:ongoingCell.cellDataInstance.remainingSecs]]];
        
        //Intensify (if available)
        if (ongoingCell.cellDataInstance.remainingSecs <= 0.5 * ongoingCell.cellDataInstance.initialTime) {
            
            if (ongoingCell.cellDataInstance.remainingSecs <= 0.1 * ongoingCell.cellDataInstance.initialTime) {
                
                //only a little time remains
                static dispatch_once_t tokenLittle;
                dispatch_once(&tokenLittle, ^(void){
                    //TODO:Prepare UserInfo With ImageName
                    [LocalNotificationHandler pushLocalNotificationWithTitle:@"Most of the time are gone!" Message:@"Are you still on the task? Hurry up, there is not much time left!" ScheduledAt:[NSDate date] Repeat:YES SoundName:nil ExtraData:nil];
                    [ongoingCell increaseIntensityWithCurrentStatus:ONGOINGSTATUS_STRESS];
                });
                
                
                
            }else{
                //Time half remain
                static dispatch_once_t tokenHalf;
                dispatch_once(&tokenHalf, ^(void){
                    //TODO:Prepare UserInfo With ImageName
                    [LocalNotificationHandler pushLocalNotificationWithTitle:@"Half way through!" Message:@"Hey! You are half way through your task! Carry on !" ScheduledAt:[NSDate date] Repeat:YES SoundName:nil ExtraData:nil];
                    [ongoingCell increaseIntensityWithCurrentStatus:ONGOINGSTATUS_MEDIUM];
                });
                
            }
        }
        
    }else{
        // Just to end the activity
        [LocalNotificationHandler pushLocalNotificationWithTitle:@"The task is now finished!" Message:@"Didn't expect this? Try next time! You can DO IT !" ScheduledAt:[NSDate date] Repeat:YES SoundName:nil ExtraData:nil];
        [GlobalNoticeHandler showHUDWithText:@"Failed! Try again next time!" ForPeriod:2.0 Success:NO Interactive:NO Callback:nil];
        
        [self stop];
        
        [ongoingCell endActivity];
        [self updateTableView];
    }
    
}

#pragma mark - Cell Controller - Past Achievement Cell
//Setup view for achievement cell
-(void)initializeAchievementCell:(AchievedActivityTableViewCell*)cell WithAchievementInstance:(PastAcheievementActivityInstance*)dataInstance{
    
    //Data Instance
    cell.pastAchievementCellInstance = dataInstance;
    /* Visible */
    //Title
    NSString * achievedTitleText = [NSString stringWithFormat:@"Title: %@",cell.pastAchievementCellInstance.finishedTitle];
    //Description
    NSString * achievedDescriptionText = [NSString stringWithFormat:@"Description: %@",cell.pastAchievementCellInstance.finishedDescription];
    //Date
    NSString * achievedDateText = [NSString stringWithFormat:@"Finished on: %@",[ActivityTableViewCellController formattedDateStringFromDate:cell.pastAchievementCellInstance.finishedDate]];
    /* Expandable */
    NSString * achievedRemainingTimeText = [ActivityTableViewCellController remainingTimeTextFromTimeComponents:[[ActivtyInstancesManager sharedManager]constructTimeComponentsWithTimeInSecs:cell.pastAchievementCellInstance.remainingSecs]];
    NSString * achievedDelayTimesText = [NSString stringWithFormat:@"Delayed: %ld times",cell.pastAchievementCellInstance.delayedTimes];
    
    //Add to textview
    cell.achievedTaskInfoText.text = [cell.achievedTaskInfoText.text stringByAppendingString:[NSString stringWithFormat:@"%@\n%@\n%@",achievedTitleText,achievedDescriptionText,achievedDateText]];
    
    //TODO :: Find out a way to expand tableviewcell
    cell.remainingTime.text = achievedRemainingTimeText;
    cell.delayedTimes.text = achievedDelayTimesText;
    
}

#pragma mark - Cell Controller - Failed activity Cell
//Set up view for achievement cell
-(void)initializeFailedActivityCell:(FailedActivityTableViewCell*)cell WithFailedInstance:(FailedActivityInstance*)dataInstance{

    //Data instance
    cell.failedCellInstance = dataInstance;
    
    //Status label
    if (cell.failedCellInstance.givenUp) {
        cell.failedActivityStatusLabel.text = @"Gave up";
    }else{
        cell.failedActivityStatusLabel.text = @"Failed";
    }
    
    //Title & Desc & Date
    NSString * failedTitleText = [NSString stringWithFormat:@"Title: %@",cell.failedCellInstance.failedTitle];
    NSString * failedDescText = [NSString stringWithFormat:@"Description: %@",cell.failedCellInstance.failedDescription];
    NSString * failedDateText = [NSString stringWithFormat:@"Failed on: %@",[ActivityTableViewCellController formattedDateStringFromDate:cell.failedCellInstance.failedDate ]];
    
    //Add to text view
    cell.failedActivityTaskInfo.text = [cell.failedActivityTaskInfo.text stringByAppendingString:[NSString stringWithFormat:@"%@\n%@\n%@",failedTitleText,failedDescText,failedDateText]];
    
}

//Received Notification ->Present UIActionSheet for picking a time
-(void)presentNewTimeSelectionSheet:(NSNotification*)notification{
    //Load the temporary trial secss
    NSDictionary* dictionary = notification.userInfo;
    tempFailedInstance = [dictionary objectForKey:@"FAILED_INSTANCE"];
    
    //Present Actionsheet
    UIActionSheet * timeSelectionSheet = [[UIActionSheet alloc]initWithTitle:@"Set the time for your activity" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use original time",@"Set a new time", nil];
    [timeSelectionSheet showInView:self.view];
}



//Delegate Method -> dismiss TimePickerViewController
-(void)dismissTimePickerViewControllerWithRetrievedTime:(long)secs{
    if (self.popupViewController != nil) {
        
        [self dismissPopupViewControllerAnimated:YES completion:^(void){
            [self.tableView setScrollEnabled:YES];
        }];
        //Make new instance
        if (tempFailedInstance) {
            [[ActivtyInstancesManager sharedManager]convertToOngoingInstanceWithFailedInstance:tempFailedInstance AndTime:secs];
        }
        [self loadOngoingInstance];
    }
}

#pragma mark - Table view Config
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 111;
            break;
        case 1:
            return 78;
            break;
        case 2:
            return 78;
            break;
        default:
            break;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //HERE IS THE REASON!
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //Create View
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    footerView.backgroundColor = [UIColor whiteColor];
    //Configure view depends on sections
    if (section == 0) {
        if ([[ActivtyInstancesManager sharedManager] getOngoingActivityInArray].count < 1) {
            UIButton * addOngoingEventButton = [UIButton buttonWithType:UIButtonTypeSystem];
            addOngoingEventButton.frame = footerView.frame;
            [addOngoingEventButton setTitle:@"Add an event" forState:UIControlStateNormal];
            [addOngoingEventButton addTarget:self action:@selector(presentEventCreationViewController) forControlEvents:UIControlEventTouchUpInside];
            addOngoingEventButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [footerView addSubview:addOngoingEventButton];
            return footerView;
        }
    }
    if (section == 1) {
        if ([[ActivtyInstancesManager sharedManager]getPastAchievementsArray].count<1) {
            UILabel * emptyPastActivityLabel = [[UILabel alloc]initWithFrame:footerView.frame];
            emptyPastActivityLabel.text = @"Oops! Do something now!";
            emptyPastActivityLabel.textAlignment = NSTextAlignmentCenter;
            
            [footerView addSubview:emptyPastActivityLabel];
            return footerView;
        }
    }
    if (section == 2) {
        if ([[ActivtyInstancesManager sharedManager]getFailedActivityArray].count<1) {
            UILabel * emptyFailedActivityLabel = [[UILabel alloc]initWithFrame:footerView.frame];
            emptyFailedActivityLabel.text = @"Great! You have no failed activities. Period.";
            emptyFailedActivityLabel.textAlignment = NSTextAlignmentCenter;
            [footerView addSubview:emptyFailedActivityLabel];
            return footerView;
        }
    }
    return footerView;
}

#pragma mark - MGSwipeCell Delegate
-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction{
    return YES;
}

-(NSArray*)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings{
    //Settings
    swipeSettings.transition = MGSwipeTransitionBorder;
    CGFloat padding = 15.0;
    NSArray * buttonArray;
    if (direction == MGSwipeDirectionLeftToRight) {
        //Ongoing cell
        if ([cell respondsToSelector:@selector(completeTask:)]) {
            NSString * focusBtnText;
            if ([ongoingCell.cellDataInstance getFocus]) {
                focusBtnText = @"Unfocus";
            }else{
                focusBtnText = @"Focus";
            }
            
            MGSwipeButton * focusBtn = [MGSwipeButton buttonWithTitle:focusBtnText backgroundColor:[UIColor colorWithRed:16.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell* sender){
                //Trigger focus mode
                if (![ongoingCell.cellDataInstance getFocus]) {
                    [ongoingCell.cellDataInstance setFocused:YES];
                    focusBtn.titleLabel.text = @"Unfocus";
                    [self updateTableView];
                    [GlobalNoticeHandler showHUDWithText:@"Focus mode enabled! Start concentrating now!" ForPeriod:1.0 Success:YES Interactive:NO Callback:nil];
                }else{
                    [ongoingCell.cellDataInstance setFocused:NO];
                    focusBtn.titleLabel.text = @"Focus";
                    [self updateTableView];
                    [GlobalNoticeHandler showHUDWithText:@"Focus mode disabled! Stretch and relax!" ForPeriod:1.0 Success:YES Interactive:NO Callback:nil];
                }
                return YES;
            }];
            
            MGSwipeButton * delayBtn = [MGSwipeButton buttonWithTitle:@"Delay" backgroundColor:[UIColor colorWithRed:145/255 green:226/255 blue:255/255 alpha:0.57] padding:padding callback:^BOOL(MGSwipeTableCell* sender){
                DelayTimeSelectionViewController * dtsvc = [[DelayTimeSelectionViewController alloc]initWithNibName:@"DelayTimeSelectionViewController" bundle:nil];
                dtsvc.delayDelegate = self;
                [self presentPopupViewController:dtsvc animated:YES completion:^(void){
                    NSLog(@"Presented");
                    [self.tableView setScrollEnabled:NO];
                    [self stop];
                }];
                return YES;
            }];
            
            MGSwipeButton * giveUpBtn = [MGSwipeButton buttonWithTitle:@"Give up" backgroundColor:[UIColor colorWithRed:255/255 green:0/255 blue:0/255 alpha:0.57] padding:padding callback:^BOOL(MGSwipeTableCell* sender){
                //End the activity
                [ongoingCell endActivity];
                //Stop timers
                [self stop];
                //Update TableView
                [self updateTableView];
                return YES;
            }];
            
            buttonArray = @[giveUpBtn,delayBtn,focusBtn];
            return buttonArray;
        }
        
        //Past Achievement Cell
        if ([cell respondsToSelector:@selector(shareTheSuccess:)]) {
            MGSwipeButton * deleteAchievementBtn = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] padding:padding callback:^BOOL(MGSwipeTableCell* sender){
                //Delete past achievements
                NSInteger index = [self.tableView indexPathForCell:cell].row;
                [[ActivtyInstancesManager sharedManager]deletePastAchievementInstanceAtIndex:index];
                [self updateTableView];
                return YES;
            }];
            
            buttonArray = @[deleteAchievementBtn];
            return buttonArray;
        }
        
        //Failed activity cell
        if ([cell respondsToSelector:@selector(retryFailedActivity:)]) {
            MGSwipeButton * deleteFailedBtn = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] padding:padding callback:^BOOL(MGSwipeTableCell* sender){
                NSInteger index = [self.tableView indexPathForCell:cell].row;
                [[ActivtyInstancesManager sharedManager]deleteFailedActivityInstanceAtIndex:index];
                [self updateTableView];
                return YES;
            }];
            
            buttonArray = @[deleteFailedBtn];
            return buttonArray;
        }
    
    }
    return nil;
}

-(void)swipeTableCell:(MGSwipeTableCell *)cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive{
    if ([cell respondsToSelector:@selector(completeTask:)]) {
        if (gestureIsActive) {
            [self stop];
        }else{
            [self resume];
        }
    }
}



#pragma mark - delayTimeVC Delegate
-(void)dismissDelayTimePopupViewController{
    if (self.popupViewController !=nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^(void){
            NSLog(@"Dismissed");
            [self.tableView setScrollEnabled:YES];
            [self resume];
        }];
    }
}
-(void)retrieveDelayedTimeInSeconds:(long)secs{
    //Add delayed seconds
    [ongoingCell.cellDataInstance delayActivityFor:secs];
}

#pragma mark - EventCreationViewController Delegate
-(void)dismissEventCreationViewControllerWithData:(BOOL)haveData{
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^(void){
            NSLog(@"Dismissed");
            [self.tableView setScrollEnabled:YES];
            //If have data, then load it 
            if (haveData) {
                [self loadOngoingInstance];
            }
        }];
    }
}

-(void)presentEventCreationViewController{
    //Show creator
    EventCreationViewController *eventCreationViewController = [[EventCreationViewController alloc]initWithNibName:@"EventCreationViewController" bundle:nil];
    eventCreationViewController.delegate = self;
    [self presentPopupViewController:eventCreationViewController animated:YES completion:^(void){
        [self.tableView setScrollEnabled:NO];
    }];
}
#pragma mark - UIActionSheetDelegate
//Pick time for converting failedInstance to Ongoing Instance
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            // Use original time
            if (tempFailedInstance) {
                [[ActivtyInstancesManager sharedManager]convertToOngoingInstanceWithFailedInstance:tempFailedInstance AndTime:tempFailedInstance.trialTime];
            }
            [self stop];
            [self loadOngoingInstance];
            [self updateTableView];
        }
            
            break;
        case 1:{
            // Present TimePickerViewController to get a new time
            if (self.popupViewController == nil) {
                // Present popup
                TimePickerViewController* tpvc = [[TimePickerViewController alloc]initWithNibName:@"TimePickerViewController" bundle:nil];
                tpvc.delegate = self;
                [self presentPopupViewController:tpvc animated:YES completion:^(void){
                    [self.tableView setScrollEnabled:NO];
                }];
                
            }
        }
            
            break;
        default:
            break;
    }
}



@end
