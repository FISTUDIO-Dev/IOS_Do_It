//
//  OngoingTableViewCell.h
//  Do it
//
//  Created by YINGGUANG CHEN on 15/5/20.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivtyInstancesManager.h"
@interface OngoingTableViewCell : UITableViewCell
//Outlets
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *ongoingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ongoingDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeNowButton;


//Data Source
@property (strong,nonatomic) OngoingActivityInstance * cellDataInstance;

//Initializer
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier datsSource:(OngoingActivityInstance*)instance;

//Actions
- (IBAction)completeTask:(id)sender;

@end
