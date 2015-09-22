//
//  NormalListActivityTableViewCell.m
//  
//
//  Created by YINGGUANG CHEN on 24/08/2015.
//
//

#import "NormalListActivityTableViewCell.h"
#import "Do_it-Swift.h"
#import "UIColor+BFPaperColors.h"
#import "BFPaperCheckbox.h"
#import "Constants.h"
@interface NormalListActivityTableViewCell()<BFPaperCheckboxDelegate>{
    DOFavoriteButton* dailyButton;
    BFPaperCheckbox* completeCheckbox;
}

@end

@implementation NormalListActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


#pragma mark - UI Elements
-(void)setUp{
    //Add daily favourite button
    dailyButton = [[DOFavoriteButton alloc]initWithFrame:CGRectMake(265, 11, 45, 45) image:[UIImage imageNamed:@"icon_heart"]];
    dailyButton.imageColorOff = [UIColor lightGrayColor];
    dailyButton.imageColorOn = [UIColor redColor];
    [dailyButton addTarget:self action:@selector(dailyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dailyButton];
    
    //Add complete checkbox
    completeCheckbox = [[BFPaperCheckbox alloc]initWithFrame:CGRectMake(305, 11, 45, 45)];
    completeCheckbox.tag = 1002;
    completeCheckbox.delegate = self;
    completeCheckbox.checkmarkColor = [UIColor paperColorLightBlue];
    completeCheckbox.rippleFromTapLocation = NO;
    [self addSubview:completeCheckbox];
    
}

#pragma mark - Button actions
-(void)dailyButtonTapped:(id)sender{
    //post notification to request update self to become daily activity
    //[[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_NORMAL_LIST_REQUEST_DAILY_AT_INDEX object:nil userInfo:@{@"rowIndex":_rowIndex}];
}

-(void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox{
    //post notification to request complete self
    //[[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_NORMAL_LIST_SET_COMPLETED object:nil userInfo:@{@"rowIndex":_rowIndex}];
}


@end
