//
//  FailedActivityTableViewCell.m
//  Do it
//
//  Created by YINGGUANG CHEN on 15/6/9.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import "FailedActivityTableViewCell.h"

@implementation FailedActivityTableViewCell

- (void)awakeFromNib {
    // Style Elements
    [self styleElements];
}


- (IBAction)retryFailedActivity:(id)sender {
    //TODO :: convert the same instance back to ongoing instance 
}

#pragma mark - UI Manipulation
-(void)styleElements{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
