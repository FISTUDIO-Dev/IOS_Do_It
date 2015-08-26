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

//row index to be assigned and to be sent back for identification
@property (strong, nonatomic) NSNumber* rowIndex;
@end
