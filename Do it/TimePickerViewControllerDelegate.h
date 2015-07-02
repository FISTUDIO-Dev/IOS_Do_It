//
//  TimePickerViewControllerDelegate.h
//  Do it
//
//  Created by Jackie Chung on 30/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

@protocol TimePickerViewControllerDelegate <NSObject>

@required
-(void)dismissTimePickerViewControllerWithRetrievedTime:(long)secs;

@end