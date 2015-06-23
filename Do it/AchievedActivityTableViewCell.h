//
//  AchievedActivityTableViewCell.h
//  Do it
//
//  Created by YINGGUANG CHEN on 15/6/8.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PastAcheievementActivityInstance.h"
#import "MGSwipeTableCell.h"
@interface AchievedActivityTableViewCell : MGSwipeTableCell
//Outlets
@property (weak, nonatomic) IBOutlet UILabel *achievedCompletedLabel;
@property (weak, nonatomic) IBOutlet UIButton *achievedShareButton;
@property (weak, nonatomic) IBOutlet UITextView *achievedTaskInfoText;

@property (assign,nonatomic) UILabel * delayedTimes;
@property (assign,nonatomic) UILabel * remainingTime;

//Property
@property (strong,nonatomic) PastAcheievementActivityInstance* pastAchievementCellInstance;

//Actions
- (IBAction)shareTheSuccess:(id)sender;


@end
