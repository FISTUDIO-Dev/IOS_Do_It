//
//  ActivitiesTableViewController.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/29.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "ActivitiesTableViewController.h"
#import "OngoingTableViewCell.h"
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
        ongoingCell = [[OngoingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OngoingCell" datsSource:ongoingInstance];
        [[NSBundle mainBundle]loadNibNamed:@"OngoingTableViewCell" owner:self options:nil];
    }
    
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
-(OngoingTableViewCell*)initializeOngoingCellViewWithOngoingInstance:(OngoingActivityInstance*)dataInstance{
    OngoingTableViewCell * cell = [[OngoingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OngoingCell"];
    //Set up data
    [cell.ongoingTitleLabel setText:dataInstance.activtyTitle ];
    [cell.ongoingDescriptionLabel setText:dataInstance.activtyTitle];
    cell.cellDataInstance = dataInstance;
    
    
}




@end
