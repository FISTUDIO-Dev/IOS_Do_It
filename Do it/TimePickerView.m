//
//  TimePickerView.m
//  Do it
//
//  Created by Jackie Chung on 19/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "TimePickerView.h"
#import "FeRippleButton.h"
#import "Constants.h"
@interface TimePickerView(){
    UILabel * infoLabel;
    FeRippleButton* proceedBtn;
}

@end
@implementation TimePickerView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    [self setBackgroundColor:[UIColor whiteColor]];
    CGRect pickerframe =CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height - 120);
    _dataPicker = [[JCDataPicker alloc]initWithFrame:pickerframe];
    _dataPicker.parentViewFrame = pickerframe;
    _dataPicker.hasSavedArea = NO;
    _dataPicker.backgroundColor = [UIColor whiteColor];
    
    CGRect labelFrame = CGRectMake(0.0, 10.0, self.frame.size.width, 44);
    infoLabel = [[UILabel alloc]initWithFrame:labelFrame];
    infoLabel.text = @"Set the time !";
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor whiteColor];
    
    //Proceed button
    proceedBtn = [[FeRippleButton alloc]initWithFrame:CGRectMake(65, 242, 130, 60)];
    [proceedBtn setImage:[UIImage imageNamed:@"icon_proceed_blue"] forState:UIControlStateNormal];
    proceedBtn.backgroundColor = [UIColor clearColor];
    proceedBtn.rippleOverBound = YES;
    proceedBtn.rippleColor = [UIColor colorWithRed:36.0f/255.0f green:215.0f/255.0f blue:247.0f/255.0f alpha:1.0];
    [proceedBtn addTarget:self action:@selector(proceedBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:proceedBtn];
    [self addSubview:_dataPicker];
    [self addSubview:infoLabel];
}

-(void)removeProceedBtn{
    
    [proceedBtn removeFromSuperview];
    
}

#pragma mark - notfication sender
-(void)proceedBtnPressed{
    //Make user info
    NSDictionary* userInfo = @{@"touch_loc":[NSValue valueWithCGPoint:proceedBtn.center],@"time":[NSNumber numberWithLong:_dataPicker.returnSecondsFromSelectedComponents]};
    //Post
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_EC_TIME_PICKER_PROCEEDING object:nil userInfo:userInfo];
}


@end
