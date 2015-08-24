//
//  NormalListActivityTableViewCell.h
//  
//
//  Created by YINGGUANG CHEN on 24/08/2015.
//
//

#import <UIKit/UIKit.h>
#import "ActivityListInstance.h"
@interface NormalListActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskContentLabel;
@property (strong, nonatomic) ActivityListInstance* cellInstance;
@end
