//
//  ActivityListTableViewController.m
//  Do it
//
//  Created by Jackie Chung on 15/08/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "ActivityListTableViewController.h"
#import "ActivtyInstancesManager.h"
#import "NormalListActivityTableViewCell.h"
#import "GlobalNoticeHandler.h"
@interface ActivityListTableViewController ()

@end

@implementation ActivityListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    
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
    NormalListActivityTableViewCell *cell = (NormalListActivityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NormalListActivityTableViewCell" owner:self options:nil]firstObject];
    }
    // Configure the cell...
    cell.taskContentLabel.text = @"test haha";
    return cell;
}




@end
