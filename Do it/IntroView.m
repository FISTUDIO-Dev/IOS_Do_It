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
@interface IntroView(){
    UILabel*introLabel;
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
    _index = 1;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    introLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 98, 213, 24)];
    introLabel.text = @"Please. Do something Now!";
    introLabel.font = [UIFont fontWithName:@"Kohinoor Devanagari" size:17];
    
    
    [self addSubview:introLabel];
}

@end
