//
//  FinalizingTaskView.m
//  Do it
//
//  Created by Jackie Chung on 23/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "FinalizingTaskView.h"
#import "FeRippleButton.h"
#import "Constants.h"

@interface FinalizingTaskView(){
    UILabel * infolabel;
    FeRippleButton* finishBtn;
}

@end
@implementation FinalizingTaskView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    //BG color
    [self setBackgroundColor:[UIColor colorWithRed:36.0f/255.0f green:215.0f/255.0f blue:247.0f/255.0f alpha:1.0]];
    
    //Just a title
    infolabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.frame.size.width, 70)];
    infolabel.textAlignment = NSTextAlignmentCenter;
    infolabel.text = @"All Good!\n Let's Do It !";
    infolabel.numberOfLines = 2;
    infolabel.font = [UIFont fontWithName:@"Kohinoor Devanagari" size:25];
    infolabel.textColor = [UIColor whiteColor];
    
    //Finish button
    finishBtn = [[FeRippleButton alloc]initWithFrame:CGRectMake(65, 242, 130, 60)];
    [finishBtn setImage:[UIImage imageNamed:@"icon_finish_white"] forState:UIControlStateNormal];
    finishBtn.backgroundColor = [UIColor clearColor];
    finishBtn.rippleOverBound = YES;
    finishBtn.rippleColor = [UIColor clearColor];
    [finishBtn addTarget:self action:@selector(finishBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    //Add to view
    [self addSubview:infolabel];
    [self addSubview:finishBtn];
}

#pragma mark - Send finishing notification
-(void)finishBtnPressed{
    //Post
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIF_EC_FINAL_FINISH object:nil userInfo:@{@"touch_loc":[NSValue valueWithCGPoint:finishBtn.center]}];
}
@end
