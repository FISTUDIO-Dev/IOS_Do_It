//
//  DelayTimeSelectionViewController.m
//  Do it
//
//  Created by Jackie Chung on 16/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "DelayTimeSelectionViewController.h"
#import "DelayTimeViewControllerDelegate.h"
#import "JCDataPicker.h"
#import "JCDataDelegate.h"
@interface DelayTimeSelectionViewController ()<JCDataPickerDelegate>{
    JCDataPicker * picker;
    IBOutlet UINavigationBar * navbar;
}

@end

@implementation DelayTimeSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Nav bar
    if (_titleText) {
        self.title = _titleText;
    }else{
        self.title = @"Get more time";
    }
    //Picker
    picker = [[JCDataPicker alloc]initWithFrame:self.view.frame];
    picker.parentViewFrame = self.view.frame;
    picker.hasSavedArea = YES;
    [picker setDelegate:self];
    [picker setBackgroundColor:[UIColor whiteColor]];
    
    //Add
    [self.view addSubview:picker];
    [self.view addSubview:navbar];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JCDataPickerDelegate
-(void)dataPicker:(JCDataPicker *)datePicker returnedSeconds:(long)secs{
    if ([_delayDelegate respondsToSelector:@selector(retrieveDelayedTimeInSeconds:)]) {
        [_delayDelegate retrieveDelayedTimeInSeconds:secs];
    }
    [self removeView];
}

-(void)removeView{
    if ([_delayDelegate respondsToSelector:@selector(dismissDelayTimePopupViewController)]) {
        [_delayDelegate dismissDelayTimePopupViewController];
    }
}




@end
