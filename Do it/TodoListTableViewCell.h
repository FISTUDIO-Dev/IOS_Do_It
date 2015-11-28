//
//  TodoListTableViewCell.h
//  Do it
//
//  Created by Jackie Chung on 28/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Do_it-Swift.h"

@interface TodoListTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel* completedDaysLabel;

@property (strong,nonatomic) UILabel* taskContentLabel;

@property (strong,nonatomic) DOFavoriteButton* setDailyBtn;

@property (strong,nonatomic) DOFavoriteButton* completeBtn;

@end
