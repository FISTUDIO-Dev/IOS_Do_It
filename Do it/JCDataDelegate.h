//
//  MGConferenceDatePickerDelegate.h
//  MGConferenceDatePicker
//
//  Created by Matteo Gobbi on 20/03/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCDataPicker;

//Protocol to return the date
@protocol JCDataPickerDelegate <NSObject>

@optional
- (void)dataPicker:(JCDataPicker *)datePicker returnedSeconds:(long)secs;
-(void)removeView;
@end

@protocol JCDataPickerDataSource <NSObject>

@required

@end
