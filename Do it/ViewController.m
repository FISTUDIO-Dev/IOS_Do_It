//
//  ViewController.m
//  Do it
//
//  Created by Jackie Chung on 23/04/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "ViewController.h"
#import "CarbonKit.h"
#import "ActivitiesTableViewController.h"
#import "ActivityListTableViewController.h"

@interface ViewController () <CarbonTabSwipeDelegate>{
    CarbonTabSwipeNavigation * tabSwipe;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *viewControllers = @[@"Task Now",@"Daily Chore"];
    UIColor *tintColor = [UIColor whiteColor];
    //Initiate tabs
    tabSwipe = [[CarbonTabSwipeNavigation alloc] createWithRootViewController:self tabNames:viewControllers tintColor:tintColor delegate:self];
    [tabSwipe setIndicatorHeight:2.0];
    [tabSwipe addShadow];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tabSwipe setTranslucent:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [tabSwipe setTranslucent:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TabSwipeDelegate
-(UIViewController*)tabSwipeNavigation:(CarbonTabSwipeNavigation *)tabSwipe viewControllerAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:{
            ActivitiesTableViewController* taskTableViewController = [[ActivitiesTableViewController alloc]initWithStyle:UITableViewStylePlain];
            return taskTableViewController;
        }
            
            break;
        case 1:{
            ActivityListTableViewController * listTableViewController = [[ActivityListTableViewController alloc]initWithStyle:UITableViewStylePlain];
            return listTableViewController;
        }
            break;
        default:
            break;
    }
    return self;
}

-(void)tabSwipeNavigation:(CarbonTabSwipeNavigation *)tabSwipe didMoveAtIndex:(NSInteger)index{
    NSLog(@"Current Index: %i",(int)index);
}

@end
