//
//  JCDataPicker
//
//  Created by Jackie Chung on 09/02/14.
//  Copyright (c) 2015 FISTUDIO. All rights reserved.
//  Credits to MGConference Data Picker
//

#import <UIKit/UIKit.h>

@protocol JCDataPickerDelegate;


//Button for save
@interface MGPickerButton : UIButton

@end


//Scroll view
@interface MGPickerScrollView : UITableView

@property NSInteger tagLastSelected;

- (void)dehighlightLastCell;
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow;

@end


//Data Picker
@interface JCDataPicker : UIView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <JCDataPickerDelegate>delegate;

@property (nonatomic) CGRect parentViewFrame;

@property (nonatomic) BOOL hasSavedArea;

@property (weak,nonatomic) NSString * btnOneText;
@property (weak,nonatomic) NSString * btnTwoText;

-(long)returnSecondsFromSelectedComponents;

@end
