//
//  TodoListTableViewCell.m
//  Do it
//
//  Created by Jackie Chung on 28/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "TodoListTableViewCell.h"

@interface TodoListTableViewCell()

@property (strong,nonatomic) UIView* completedDaysLabelContainer;

@end

@implementation TodoListTableViewCell

-(void)awakeFromNib{
    
    [self setUp];
    
}

-(void)setUp{
    
    // set up completed days label container
    _completedDaysLabelContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width / 5, self.frame.size.height / 6)];
    
    _completedDaysLabelContainer.backgroundColor = [UIColor colorWithRed:102 green:255 blue:153 alpha:0.9];
    
    [self addSubview:_completedDaysLabel];
    
    // @todo
    
    
}

@end
