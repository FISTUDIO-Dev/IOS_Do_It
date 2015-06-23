//
//  DelayTimeViewControllerDelegate.h
//  Do it
//
//  Created by Jackie Chung on 16/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol delayViewControllerDelegate <NSObject>

@required
-(void)dismissDelayTimePopupViewController;
-(void)retrieveDelayedTimeInSeconds:(long)secs;
@end

