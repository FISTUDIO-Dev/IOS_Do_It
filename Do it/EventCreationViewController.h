//
//  EventCreationViewController.h
//  Do it
//
//  Created by Jackie Chung on 16/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventCreationDelegate.h"
#import "IntroView.h"
#import "TaskCreation.h"
#import "TimePickerView.h"
#import "FinalizingTaskView.h"
@interface EventCreationViewController : UIViewController
@property (strong, nonatomic) IntroView *introView;
@property (strong,nonatomic) TaskCreation *taskView;
@property (strong,nonatomic) TimePickerView * pickerView;
@property (strong,nonatomic) FinalizingTaskView * finalView;

@property (weak,nonatomic) id <EventCreationDelegate>delegate;
@end
