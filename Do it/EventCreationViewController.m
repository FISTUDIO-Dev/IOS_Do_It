//
//  EventCreationViewController.m
//  Do it
//
//  Created by Jackie Chung on 16/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "EventCreationViewController.h"
#import "UIView+MaterialDesign.h"
#import "UIColor+flat.h"
#import "FeRippleButton.h"
#import "OngoingActivityInstance.h"
#import "ActivtyInstancesManager.h"
@interface EventCreationViewController (){
    FeRippleButton*proceedBtn;
    NSArray * viewArray;
    NSInteger currentViewIndex;
    
    //Construction output
    OngoingActivityInstance * constructingInstance;
}

@end

@implementation EventCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Init
    currentViewIndex = 0;
    constructingInstance = [[OngoingActivityInstance alloc]init];
    //Set up view
    [self setUpViews];
    //Set up buttons
    [self setUpViewContents];
}

#pragma mark - Set up UI Elements
-(void)setUpViews{
    CGRect frame = CGRectMake(2.0, 2.0, self.view.frame.size.width-4, self.view.frame.size.height-4);
    
    _introView = [[IntroView alloc]initWithFrame:frame];
    _taskView = [[TaskCreation alloc]initWithFrame:frame];
    _pickerView = [[TimePickerView alloc]initWithFrame:frame];
    _finalView = [[FinalizingTaskView alloc]initWithFrame:frame];
    
    // more to come...
    viewArray = @[_introView,_taskView,_pickerView,_finalView];
    // add first view to the controller
    [self.view addSubview:_introView];

}

-(void)setUpViewContents{
    for (int i = 0; i<viewArray.count; i++) {
        //Add buttons
        [self buildTransitionButtonInViewWithIndex:i];
        //Initialize Views
        [self initializeViewAtIndex:i];
    }
}

-(void)initializeViewAtIndex:(NSInteger)index{
    // shadow setup
    [[[viewArray objectAtIndex:index] layer] setShadowOffset:CGSizeMake(0.5, 0.5)];
    [[[viewArray objectAtIndex:index] layer] setShadowColor:[UIColor grayColor].CGColor];
    [[[viewArray objectAtIndex:index] layer] setShadowRadius:3.0f];
    [[[viewArray objectAtIndex:index] layer] setShadowOpacity:0.8f];
    
    //round corner
    [[[viewArray objectAtIndex:index] layer] setCornerRadius:5.0f];
}

-(void)buildTransitionButtonInViewWithIndex:(NSInteger)index{
    
    UIColor * firstColor = [UIColor colorWithRed:109.0f/255.0f green:198.0f/255.0f blue:192.0f/255.0f alpha:1.0];
    UIColor * secondColor = [UIColor whiteColor];
    UIColor * thirdColor = [UIColor colorWithRed:36.0f/255.0f green:215.0f/255.0f blue:247.0f/255.0f alpha:1.0];
    UIColor * fourthColor = [UIColor whiteColor];
    NSArray * colorArray = @[firstColor,secondColor,thirdColor,fourthColor];
    
    proceedBtn = [[FeRippleButton alloc]initWithFrame:CGRectMake(65, 242, 130, 60)];
    //for all the following view
    if ([[viewArray objectAtIndex:index] backgroundColor] == [UIColor whiteColor]) {
        [proceedBtn setImage:[UIImage imageNamed:@"icon_proceed_blue"] forState:UIControlStateNormal];
    }else{
        if (index == 3) {
            [proceedBtn setImage:[UIImage imageNamed:@"icon_finish_white"] forState:UIControlStateNormal];
        }else{
            [proceedBtn setImage:[UIImage imageNamed:@"icon_proceed_white"] forState:UIControlStateNormal];
        }
        
    }
    
    proceedBtn.backgroundColor = [UIColor clearColor];
    [proceedBtn addTarget:self action:@selector(jumpToNextView:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    //Configuration
    proceedBtn.rippleOverBound =YES;
    proceedBtn.rippleColor = colorArray[index];
    
    [[viewArray objectAtIndex:index]addSubview:proceedBtn];
}


-(void)jumpToNextView:(UIButton *)sender forEvent:(UIEvent *)event{
    
    CGPoint exactTouchPosition = [[[event allTouches] anyObject] locationInView:[viewArray objectAtIndex:currentViewIndex]];
    NSInteger previousIndex = currentViewIndex;
    //Contruct data
    switch (currentViewIndex) {
        case 1:{
            [self setDataWithTitle:_taskView.titleText.text Description:_taskView.descText.text];
        }
            break;
        case 2:{
            [self setDataWithTimeRemainingSeconds:[_pickerView.dataPicker returnSecondsFromSelectedComponents]];
        }
        case 3:{
            [self addDataInstance];
        }
            break;
        default:
            break;
    }
    
    //Proceed to next view
    currentViewIndex ++;
    if (currentViewIndex <= 3) {
        [UIView mdInflateTransitionFromView:[viewArray objectAtIndex:previousIndex] toView:[viewArray objectAtIndex:currentViewIndex] originalPoint:exactTouchPosition duration:0.65 completion:^(void){
            // Set Completion Methods
        }];
    }else{
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        UIView* nilView = [[UIView alloc]initWithFrame:self.view.frame];
        nilView.backgroundColor = [UIColor whiteColor];

        [UIView animateWithDuration:1.0 animations:^(void){
            [self.view setAlpha:0.0];
        }];
        
        [UIView mdDeflateTransitionFromView:[viewArray objectAtIndex:previousIndex] toView:nilView originalPoint:exactTouchPosition duration:0.65 completion:^(void){
            if ([_delegate respondsToSelector:@selector(dismissEventCreationViewController)]) {
                [_delegate dismissEventCreationViewController];
            }
        }];
    }
    
}

#pragma mark - Construct Data
-(void)setDataWithTitle:(NSString*)title Description:(NSString*)desc{
    constructingInstance.activtyTitle = title;
    constructingInstance.activityDescription = desc;
}

-(void)setDataWithTimeRemainingSeconds:(long)secs{
    constructingInstance.remainingSecs = secs;
}

-(void)addDataInstance{
    [[ActivtyInstancesManager sharedManager]addOngoingActivity:constructingInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
