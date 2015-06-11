//
//  FailedActivityTableViewCell.h
//  Do it
//
//  Created by YINGGUANG CHEN on 15/6/9.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FailedActivityInstance.h"
#import "MGSwipeTableCell.h"
@interface FailedActivityTableViewCell : MGSwipeTableCell

//Outlets
@property (weak, nonatomic) IBOutlet UILabel *failedActivityStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *failedActivityRetryBtn;
@property (weak, nonatomic) IBOutlet UITextView *failedActivityTaskInfo;

//Property
- (IBAction)retryFailedActivity:(id)sender;

//Data
@property (strong, nonatomic) FailedActivityInstance* failedCellInstance;

@end
