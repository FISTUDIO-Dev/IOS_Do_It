//
//  TaskCreation.m
//  Do it
//
//  Created by Jackie Chung on 17/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "TaskCreation.h"
#import "GlobalNoticeHandler.h"
#import "FeRippleButton.h"
#import "Constants.h"
#import "Do_it-Swift.h"

@interface TaskCreation()<UITextFieldDelegate>{
    UILabel * infoLabel;
    UILabel * focusLabel;
    
    FeRippleButton* proceedBtn;
}
@property (strong, nonatomic) MKTextField * titleText;
@property (strong, nonatomic) MKTextField * descText;
@property (strong,nonatomic) UISwitch * focusModeSwitch;
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
    _titleText.placeholder = @"Title";
    _titleText.tintColor = [UIColor grayColor];
    _titleText.backgroundColor = [UIColor whiteColor];
    
    //Desc text
    _descText = [[MKTextField alloc]initWithFrame:CGRectMake(37, 122, 183, 45)];
    _descText.layer.borderColor = [[UIColor clearColor]CGColor];
    _descText.floatingPlaceholderEnabled = true;
    _descText.placeholder = @"Description";
    _descText.tintColor = [UIColor grayColor];
    _descText.backgroundColor = [UIColor whiteColor];
    
    //Focus label
    focusLabel = [[UILabel alloc]initWithFrame:CGRectMake(37, 182, 109, 21)];
    focusLabel.text = @"Focus mode:";
    focusLabel.textColor = [UIColor whiteColor];
    
    //Focus switch
    self.focusModeSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(171, 177, 51, 31)];
    [_focusModeSwitch setOn:NO];
    [_focusModeSwitch addTarget:self action:@selector(toggleFocusMode:) forControlEvents:UIControlEventValueChanged];

    //Proceed button
    proceedBtn = [[FeRippleButton alloc]initWithFrame:CGRectMake(65, 242, 130, 60)];
    [proceedBtn setImage:[UIImage imageNamed:@"icon_proceed_white"] forState:UIControlStateNormal];
    proceedBtn.backgroundColor = [UIColor clearColor];
    proceedBtn.rippleOverBound = YES;
    proceedBtn.rippleColor = [UIColor whiteColor];
    [proceedBtn addTarget:self action:@selector(proceedPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //Add to view
    [self addSubview:infoLabel];
    [self addSubview:_titleText];
    [self addSubview:_descText];
    [self addSubview:focusLabel];
    [self addSubview:_focusModeSwitch];
    [self addSubview:proceedBtn];
    //Textfield delegate
    [_titleText setDelegate:self];
    [_descText setDelegate:self];
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //Validate
    if ([_titleText.text isEqualToString:@""] ||[_descText.text isEqualToString:@""]) {
        [GlobalNoticeHandler createInformationalAlertViewWithTitle:@"Oops" Description:@"Please fill in the required fields" ButtonText:@"Ok"];
        
        return NO;
    }
    [textField resignFirstResponder];

    //Set text
    _titleTextString = _titleText.text;
    _descTextString = _descText.text;
    return YES;
}

#pragma mark - Proceed btn send notification
-(void)proceedPressed{
    //Make user info
    NSDictionary* userInfo = @{@"touch_loc":[NSValue valueWithCGPoint:proceedBtn.center],@"task_title":_titleText.text,@"task_desc":_descText.text,@"focused":[NSNumber numberWithBool:_isFocus]};
    //Post notification
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_EC_TASK_VIEW_PROCEEDING object:nil userInfo:userInfo];
}

#pragma mark - Switch Changed
-(void)toggleFocusMode:(id)sender{
    if ([(UISwitch*)sender isOn] == YES) {
        [GlobalNoticeHandler createInformationalAlertViewWithTitle:@"Focus mode enabled" Description:@"With focus mode, if you leave app for more than 10 seconds, the task is failed!" ButtonText:@"I Get It"];
        _isFocus = YES;
    }else{
        _isFocus = NO;
    }
}
@end
