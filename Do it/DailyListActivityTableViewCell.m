//
//  DailyListActivityTableViewCell.m
//  
//
//  Created by YINGGUANG CHEN on 24/08/2015.
//
//

#import "DailyListActivityTableViewCell.h"
#import "BFPaperCheckbox.h"
#import "UIColor+BFPaperColors.h"
#import "Do_it-Swift.h"

@interface DailyListActivityTableViewCell()<BFPaperCheckboxDelegate>{
    DOFavoriteButton* setAlarmButton;
    BFPaperCheckbox* setCompleteCheckbox;
}

@end
@implementation DailyListActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

#pragma mark - UI Initialization
-(void)setUp{
    setAlarmButton = [[DOFavoriteButton alloc]initWithFrame:CGRectMake(235, 15, 35, 35) image:[UIImage imageNamed:@"icon_clock"]];
    setAlarmButton.imageColorOff = [UIColor lightGrayColor];
    setAlarmButton.imageColorOn = [UIColor paperColorAmber];
    //TODO::
    
}

#pragma mark - Button Actions

-(void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox{
    
}
@end
