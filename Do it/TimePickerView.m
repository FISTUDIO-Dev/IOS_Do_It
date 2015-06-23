//
//  TimePickerView.m
//  Do it
//
//  Created by Jackie Chung on 19/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "TimePickerView.h"
@interface TimePickerView(){
    UILabel * infoLabel;
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
    
    [self addSubview:_dataPicker];
    [self addSubview:infoLabel];
}


@end
