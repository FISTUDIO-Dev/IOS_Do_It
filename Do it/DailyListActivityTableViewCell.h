//
//  DailyListActivityTableViewCell.h
//  
//
//  Created by YINGGUANG CHEN on 24/08/2015.
//
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
@interface DailyListActivityTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UILabel *completionRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskContentLabel;

@end
