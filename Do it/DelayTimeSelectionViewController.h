//
//  DelayTimeSelectionViewController.h
//  Do it
//
//  Created by Jackie Chung on 16/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol delayViewControllerDelegate;
@interface DelayTimeSelectionViewController : UIViewController

@property (weak,nonatomic)id <delayViewControllerDelegate>delayDelegate;
@end
