//
//  IntroView.m
//  Do it
//
//  Created by Jackie Chung on 16/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "IntroView.h"
#import "UIColor+flat.h"
#import "FeRippleButton.h"
#import "Constants.h"
@interface IntroView(){
    UILabel*introLabel;
    
    FeRippleButton *proceedBtn;
    FeRippleButton *cancelBtn;
}


@end

@implementation IntroView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Initialize
        [self setUp];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //Initialize
        [self setUp];
    }
    return self;
}

-(void)setUp{    
    [self setBackgroundColor:[UIColor whiteColor]];
    //Intro label
    introLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 98, 213, 24)];
    introLabel.text = @"Please. Do something Now!";
    introLabel.font = [UIFont fontWithName:kSF_FONT_REGULAR size:17];
    //Button procceed
    proceedBtn = [[FeRippleButton alloc]initWithFrame:CGRectMake(65, 212, 130, 60)];
    proceedBtn.backgroundColor = [UIColor clearColor];
    [proceedBtn setImage:[UIImage imageNamed:@"icon_proceed_blue"] forState:UIControlStateNormal];
    proceedBtn.rippleOverBound = YES;
    proceedBtn.rippleColor = [UIColor colorWithRed:109.0f/255.0f green:198.0f/255.0f blue:192.0f/255.0f alpha:0.9];
    [proceedBtn addTarget:self action:@selector(proceedPressed) forControlEvents:UIControlEventTouchUpInside];
    //Button Cancelled
    cancelBtn = [[FeRippleButton alloc]initWithFrame:CGRectMake(115, 290, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_cancel_red"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    cancelBtn.rippleOverBound = YES;
    cancelBtn.rippleColor = [UIColor whiteColor];
    [cancelBtn addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancelBtn];
    [self addSubview:proceedBtn];
    [self addSubview:introLabel];
}

//Proceed button action
-(void)proceedPressed{
    //Make user info
    NSDictionary* userInfo = @{@"index":@0,@"touch_loc":[NSValue valueWithCGPoint:proceedBtn.center]};
    //Post notification
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_EC_INTRO_VIEW_PROCEEDING object:nil userInfo:userInfo];
}

-(void)cancelPressed{
    //Post notification
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_EC_INTRO_VIEW_CANCELLING object:nil];
}

@end
