//
//  TaskCreation.m
//  Do it
//
//  Created by Jackie Chung on 17/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "TaskCreation.h"
@interface TaskCreation()<UITextFieldDelegate>{
    UILabel * infoLabel;
}

@end
@implementation TaskCreation


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //Init
        [self setUp];
    }
    return self;
}

-(void)setUp{
    [self setBackgroundColor:[UIColor colorWithRed:109.0f/255.0f green:198.0f/255.0f blue:192.0f/255.0f alpha:1.0]];
    //Info Label
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 10.0, self.frame.size.width, 44)];
    infoLabel.text = @"Add some details";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor whiteColor];
    
    //Title text
    _titleText = [[MKTextField alloc]initWithFrame:CGRectMake(37, 61, 183, 45)];
    _titleText.layer.borderColor = [UIColor clearColor].CGColor;
    _titleText.floatingPlaceholderEnabled = true;
    _titleText.placeholder = @"Enter task title";
    _titleText.tintColor = [UIColor whiteColor];
    _titleText.cornerRadius = 0;
    _titleText.bottomBorderEnabled = true;
    _titleText.textColor = [UIColor whiteColor];
    
    //Desc text
    _descText = [[MKTextField alloc]initWithFrame:CGRectMake(37, 125, 183, 45)];
    _descText.layer.borderColor = [[UIColor clearColor]CGColor];
    _descText.floatingPlaceholderEnabled = true;
    _descText.placeholder = @"Enter task description";
    _descText.tintColor = [UIColor whiteColor];
    _descText.cornerRadius = 0;
    _descText.bottomBorderEnabled = true;
    _descText.textColor = [UIColor whiteColor];
    
    //Add to view
    [self addSubview:infoLabel];
    [self addSubview:_titleText];
    [self addSubview:_descText];

    //Delegate
    [_titleText setDelegate:self];
    [_descText setDelegate:self];
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
