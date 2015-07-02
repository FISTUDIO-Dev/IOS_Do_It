//
//  TimePickerViewController.m
//  Do it
//
//  Created by Jackie Chung on 29/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "TimePickerViewController.h"
#import "FeRippleButton.h"
@interface TimePickerViewController (){
    FeRippleButton* setBtn;
}

@end

@implementation TimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUp];
    
}

-(void)setUp{
    // Set up time picker
    _timePickerView = [[TimePickerView alloc]initWithFrame:self.view.frame];
    // Add to view
    [self.view addSubview:_timePickerView];
    
    // Set up finish button
    setBtn = [[FeRippleButton alloc]initWithFrame:CGRectMake(65, 255, 180, 60)];
    setBtn.center = CGPointMake(self.view.frame.size.width/2, setBtn.frame.origin.y);
    [setBtn setTitle:@"Set a new time !" forState:UIControlStateNormal];
    [setBtn setBackgroundColor:[UIColor colorWithRed:109.0f/255.0f green:198.0f/255.0f blue:192.0f/255.0f alpha:0.8]];
    [setBtn addTarget:self action:@selector(finishUp) forControlEvents:UIControlEventTouchUpInside];
    [setBtn.layer setCornerRadius:4.0];
    setBtn.rippleColor = [UIColor whiteColor];
    [self.view addSubview:setBtn];
}

-(void)finishUp{
    // retrieve seconds
    long secs = _timePickerView.dataPicker.returnSecondsFromSelectedComponents;
    // send to delegate
    if ([_delegate respondsToSelector:@selector(dismissTimePickerViewControllerWithRetrievedTime:)]) {
        [_delegate dismissTimePickerViewControllerWithRetrievedTime:secs];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
