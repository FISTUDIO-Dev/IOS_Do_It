//
//  TimePickerViewController.h
//  Do it
//
//  Created by Jackie Chung on 29/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerView.h"
#import "TimePickerViewControllerDelegate.h"
@interface TimePickerViewController : UIViewController
@property(strong,nonatomic)TimePickerView* timePickerView;
@property(weak,nonatomic) id <TimePickerViewControllerDelegate>delegate;
@end
