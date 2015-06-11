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
@interface ActivitiesTableViewController (){
    //Ongoings
    OngoingActivityInstance * ongoingInstance;
    OngoingTableViewCell * ongoingCell;
    
}
@property(nonatomic,weak)NSTimer * ongoingTimer;

@end

@implementation ActivitiesTableViewController

- (void)viewWillAppear:(BOOL)animated{
    //Preload data
    
    //create an ongoing instance for test
    OngoingActivityInstance * testInstance = [[OngoingActivityInstance alloc]initWithTitle:@"test" mainDescription:@"test description" remainingSecs:120];
    //copy
    ongoingInstance = testInstance;
    //add
    [[ActivtyInstancesManager sharedManager]addOngoingActivity:ongoingInstance];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Intialize Ongoing Cell Timer
    //Initialize timer
    self.ongoingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateOngoingCellText) userInfo:nil repeats:YES];

    [[NSRunLoop mainRunLoop]addTimer:self.ongoingTimer forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
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
                achievementCell = [[[NSBundle mainBundle]loadNibNamed:@"AchievedActivityTableViewCell" owner:self options:nil]objectAtIndex:0 ];
            }
            achievementCell.delegate = self;
        }
            break;
        case 2:{
            //Create
            FailedActivityTableViewCell * failedCell = (FailedActivityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"failedCell"];
            if (failedCell == nil) {
                failedCell = [[[NSBundle mainBundle]loadNibNamed:@"FailedActivityTableViewCell" owner:self options:nil]objectAtIndex:0];
            }
            failedCell.delegate = self;
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
    if (currentRemainingSeconds >0) {
        ongoingCell.cellDataInstance.remainingSecs--;
        
        //Update text from ongoing instance
        [ongoingCell.timeLeftLabel setText:[ActivityTableViewCellController timeLeftLabelTextFromTimeComponents:[[ActivtyInstancesManager sharedManager]constructTimeComponentsWithTimeInSecs:ongoingCell.cellDataInstance.remainingSecs]]];
        
        //Intensify (if available)
        if (ongoingCell.cellDataInstance.remainingSecs <= 0.5 * ongoingCell.cellDataInstance.initialTime) {
            if (ongoingCell.cellDataInstance.remainingSecs <=0.1 * ongoingCell.cellDataInstance.initialTime) {
                [ongoingCell increaseIntensityWithCurrentStatus:ONGOINGSTATUS_STRESS];
                //update status
                ongoingCell.cellDataInstance.statusCode = ONGOINGSTATUS_STRESS;
            }else{
                [ongoingCell increaseIntensityWithCurrentStatus:ONGOINGSTATUS_MEDIUM];
                //update status
                ongoingCell.cellDataInstance.statusCode = ONGOINGSTATUS_MEDIUM;
            }
        }
        
    }else{
        [self.ongoingTimer invalidate];
    }
    
}

#pragma mark - Cell Controller - Past Achievement Cell
//Setup view for achievement cell
-(void)initializeAchievementCell:(AchievedActivityTableViewCell*)cell WithAchievementInstance:(PastAcheievementActivityInstance*)dataInstance{
    
    //TODO :: Initialize
    NSString * achievedTitleText = [NSString stringWithFormat:@"Title: %@",dataInstance.finishedTitle];
    NSString * achievedDescriptionText = [NSString stringWithFormat:@"Description: %@",dataInstance.finishedDescription];
    
}

#pragma mark - Cell Controller - Failed activity Cell
//Set up view for achievement cell
-(void)initializeFailedActivityCell:(FailedActivityTableViewCell*)cell WithFailedInstance:(FailedActivityInstance*)dataInstance{
    
    //TODO :: Initialize
}


#pragma mark - Table view Config
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 111;
            break;
        case 1:
            return 78;
        case 2:
            return 78;
        default:
            break;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //Create View
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    footerView.backgroundColor = [UIColor clearColor];
    //Configure view depends on sections
    if (section == 0) {
        if ([[ActivtyInstancesManager sharedManager] getOngoingActivityInArray].count<1) {
            //TODO :: Use a default button for replacement for now
            UIButton * addOngoingEventButton = [UIButton buttonWithType:UIButtonTypeSystem];
            addOngoingEventButton.frame = footerView.frame;
            addOngoingEventButton.titleLabel.text = @"Add an Activity";
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
    return nil;
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
    if (direction == MGSwipeDirectionRightToLeft) {
        //Ongoing cell
        if ([cell respondsToSelector:@selector(completeTask:)]) {
            MGSwipeButton * delayBtn = [MGSwipeButton buttonWithTitle:@"Delay" backgroundColor:[UIColor colorWithRed:123/255 green:241/255 blue:255/255 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell* sender){
                //TODO :: Delay action
                return NO;
            }];
            
            MGSwipeButton * giveUpBtn = [MGSwipeButton buttonWithTitle:@"Give up" backgroundColor:[UIColor redColor] padding:padding callback:^BOOL(MGSwipeTableCell* sender){
                //TODO :: Give up action
                return NO;
            }];
            
            buttonArray = @[giveUpBtn,delayBtn];
            return buttonArray;
        }
        
        //Past Achievement Cell
        if ([cell respondsToSelector:@selector(shareTheSuccess:)]) {
            MGSwipeButton * deleteAchievementBtn = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] padding:padding callback:^BOOL(MGSwipeTableCell* sender){
                //TODO:: Delete past achievement
                return NO;
            }];
            
            buttonArray = @[deleteAchievementBtn];
            return buttonArray;
        }
        
        //Failed activity cell
        if ([cell respondsToSelector:@selector(retryFailedActivity:)]) {
            MGSwipeButton * deleteFailedBtn = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] padding:padding callback:^BOOL(MGSwipeTableCell* sender){
                //TODO:: Delete past achievement
                return NO;
            }];
            
            buttonArray = @[deleteFailedBtn];
            return buttonArray;
        }
    
    }
    return nil;
}

-(void)swipeTableCell:(MGSwipeTableCell *)cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive{
    
    //TODO :: Add blur to indicate that timer is still ongoing
    NSLog(@"Swiped..");
}




@end
