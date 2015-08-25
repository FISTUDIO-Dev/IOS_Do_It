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
@interface NormalListActivityTableViewCell()<BFPaperCheckboxDelegate>
@property (strong,nonatomic) DOFavoriteButton* dailyButton;
@property (strong,nonatomic) BFPaperCheckbox* completeCheckbox;
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
    self.dailyButton = [[DOFavoriteButton alloc]initWithFrame:CGRectMake(231, 16, 34, 34) image:[UIImage imageNamed:@"icon_heart"]];
    self.dailyButton.imageColorOff = [UIColor lightGrayColor];
    self.dailyButton.imageColorOn = [UIColor redColor];
    [self.dailyButton addTarget:self action:@selector(dailyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.dailyButton];
    
    //Add complete checkbox
    self.completeCheckbox = [[BFPaperCheckbox alloc]initWithFrame:CGRectMake(275, 16, 34, 34)];
    self.completeCheckbox.tag = 1002;
    self.completeCheckbox.delegate = self;
    self.completeCheckbox.checkmarkColor = [UIColor paperColorLightBlue];
    self.completeCheckbox.rippleFromTapLocation = NO;
    [self addSubview:self.completeCheckbox];
    
}

#pragma mark - Button actions
-(void)dailyButtonTapped:(id)sender{
    
}

-(void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox{
    
}


@end
