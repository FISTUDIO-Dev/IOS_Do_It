//
//  AchievedActivityTableViewCell.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/6/8.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "AchievedActivityTableViewCell.h"

@implementation AchievedActivityTableViewCell

#pragma mark - Overriden
- (void)awakeFromNib {
    // style elements
    [self styleElements];
}


#pragma mark - UI Manipulation
-(void)styleElements{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - Actions
- (IBAction)shareTheSuccess:(id)sender {
    //TODO :: Share the achievement on social networks
}

@end
