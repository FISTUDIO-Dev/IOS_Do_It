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

- (void)viewDidLoad {
    [super viewDidLoad];
    //create an ongoing instance
    OngoingActivityInstance * testInstance = [[OngoingActivityInstance alloc]initWithTitle:@"test" mainDescription:@"test description" remainingSecs:120];
    //copy
    ongoingInstance = [testInstance copy];
    //add
    [[ActivtyInstancesManager sharedManager]addOngoingActivity:ongoingInstance];
    
    
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
    OngoingTableViewCell * ongoingCell = [tableView dequeueReusableCellWithIdentifier:@"OngoingCell"];
    //Configure
    ongoingCell.cellDataInstance = ongoingInstance;
    
    
    if (!ongoingCell) {
        [tableView registerNib:[UINib nibWithNibName:@"OngoingTableViewCell.xib" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OngoingCell"];
    }
    
    return ongoingCell;
}




@end
