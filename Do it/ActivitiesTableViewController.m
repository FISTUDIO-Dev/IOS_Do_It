//
//  ActivitiesTableViewController.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/29.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivitiesTableViewController.h"
#import "OngoingTableViewCell.h"
#import "ActivityTableViewCellController.h"
@interface ActivitiesTableViewController (){
    OngoingActivityInstance * ongoingInstance;
}

@end

@implementation ActivitiesTableViewController

- (void)viewWillAppear:(BOOL)animated{
    //Preload data
    //create an ongoing instance
    OngoingActivityInstance * testInstance = [[OngoingActivityInstance alloc]initWithTitle:@"test" mainDescription:@"test description" remainingSecs:120];
    //copy
    ongoingInstance = testInstance;
    //add
    [[ActivtyInstancesManager sharedManager]addOngoingActivity:ongoingInstance];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Create
    OngoingTableViewCell * ongoingCell = (OngoingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OngoingCell"];
    
    if(ongoingCell == nil){
        ongoingCell = [[[NSBundle mainBundle]loadNibNamed:@"OngoingTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    [self initializeOngoingCell:ongoingCell WithOngoingInstance:ongoingInstance];

    NSLog(@"%@",ongoingCell.ongoingDescriptionLabel.text);
    return ongoingCell;
}

#pragma mark - Cell Configure
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 111;
}

#pragma mark - Cell Controller
//Ongoing Cell
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






@end
