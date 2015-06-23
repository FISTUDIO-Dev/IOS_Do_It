//
//  JCDataPicker
//
//  Created by Jackie Chung on 09/02/14.
//  Copyright (c) 2015 FISTUDIO. All rights reserved.
//  Credits to MGConference Data Picker
//


#import "JCDataPicker.h"
#import "JCDataDelegate.h"

#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 )
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//Editable macros
#define TEXT_COLOR [UIColor colorWithWhite:0.5 alpha:1.0]
#define SELECTED_TEXT_COLOR [UIColor whiteColor]
#define LINE_COLOR [UIColor colorWithWhite:0.80 alpha:1.0]
#define SAVE_AREA_COLOR [UIColor colorWithWhite:0.95 alpha:1.0]
#define BAR_SEL_COLOR [UIColor colorWithRed:76.0f/255.0f green:172.0f/255.0f blue:239.0f/255.0f alpha:0.8]

//Editable constants
float VALUE_HEIGHT = 65.0;
float SAVE_AREA_HEIGHT = 70.0;
float SAVE_AREA_MARGIN_TOP = 20.0;
float DL_HOURS_WIDTH = 100.0;
float DL_MINUTES_WIDTH = 100.0;
float DL_SECS_WIDTH = 100.0;
float PICKER_TEXT_SIZE = 19.0;

//Editable values
float PICKER_HEIGHT = 150;
NSString *FONT_NAME = @"HelveticaNeue";

//Static macros and constants
#define SELECTOR_ORIGIN (PICKER_HEIGHT/2.0-VALUE_HEIGHT/2.0)
#define SAVE_AREA_ORIGIN_Y self.bounds.size.height-SAVE_AREA_HEIGHT
#define PICKER_ORIGIN_Y SAVE_AREA_ORIGIN_Y-SAVE_AREA_MARGIN_TOP-PICKER_HEIGHT
#define BAR_SEL_ORIGIN_Y PICKER_HEIGHT/2.0-VALUE_HEIGHT/2.0


//Custom UIButton
@implementation MGPickerButton

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:BAR_SEL_COLOR forState:UIControlStateNormal];
        [self setTitleColor:SELECTED_TEXT_COLOR forState:UIControlStateHighlighted];
        [self.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:18.0]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat outerMargin = 5.0f;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);
    CGFloat radius = 6.0;
    
    CGMutablePathRef outerPath = CGPathCreateMutable();
    CGPathMoveToPoint(outerPath, NULL, CGRectGetMidX(outerRect), CGRectGetMinY(outerRect));
    CGPathAddArcToPoint(outerPath, NULL, CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect), CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect), radius);
    CGPathAddArcToPoint(outerPath, NULL, CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect), CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect), radius);
    CGPathAddArcToPoint(outerPath, NULL, CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect), CGRectGetMinX(outerRect), CGRectGetMinY(outerRect), radius);
    CGPathAddArcToPoint(outerPath, NULL, CGRectGetMinX(outerRect), CGRectGetMinY(outerRect), CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect), radius);
    CGPathCloseSubpath(outerPath);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, (self.state != UIControlStateHighlighted) ? BAR_SEL_COLOR.CGColor : SELECTED_TEXT_COLOR.CGColor);
    CGContextAddPath(context, outerPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

@end


//Custom scrollView
@interface MGPickerScrollView ()

@property (nonatomic, strong) NSArray *arrValues;
@property (nonatomic, strong) UIFont *cellFont;
@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;

@end


@implementation MGPickerScrollView

//Constants
const float LBL_BORDER_OFFSET = 8.0;

//Configure the tableView
- (id)initWithFrame:(CGRect)frame andValues:(NSArray *)arrayValues
      withTextAlign:(NSTextAlignment)align andTextSize:(float)txtSize {
    
    if(self = [super initWithFrame:frame]) {
        [self setScrollEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setContentInset:UIEdgeInsetsMake(BAR_SEL_ORIGIN_Y, 0.0, BAR_SEL_ORIGIN_Y, 0.0)];
        
        _cellFont = [UIFont fontWithName:FONT_NAME size:txtSize];
        
        
        if(arrayValues)
            _arrValues = [arrayValues copy];
    }
    return self;
}


//Dehighlight the last cell
- (void)dehighlightLastCell {
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self setTagLastSelected:-1];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
}

//Highlight a cell
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow {
    [self setTagLastSelected:indexPathRow];
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
}

@end


//Custom Data Picker
@interface JCDataPicker (){
    UIView * saveArea;
}

@property (nonatomic, strong) NSArray *arrHours;
@property (nonatomic, strong) NSArray *arrMins;
@property (nonatomic, strong) NSArray *arrSecs;

@property (nonatomic, strong) MGPickerScrollView *dlHours;
@property (nonatomic, strong) MGPickerScrollView *dlMins;
@property (nonatomic, strong) MGPickerScrollView *dlSecs;

@property (nonatomic, strong) MGPickerButton *delayButton;
@property (nonatomic, strong) MGPickerButton *cancelButton;
@end


@implementation JCDataPicker

-(void)drawRect:(CGRect)rect {
    [self initialize];
    [self buildControl];
}

- (void)initialize {
    _parentViewFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    if (!CGRectIsEmpty(_parentViewFrame)) {
        DL_HOURS_WIDTH = _parentViewFrame.size.width/3;
        DL_MINUTES_WIDTH = _parentViewFrame.size.width/3;
        DL_SECS_WIDTH = _parentViewFrame.size.width/3;
        PICKER_HEIGHT = _parentViewFrame.size.height;
        PICKER_TEXT_SIZE = 14.0;
        VALUE_HEIGHT = 45.0;
    }
    
    //Create array secs
    NSMutableArray * arrSeconds = [[NSMutableArray alloc]initWithCapacity:60];
    [arrSeconds addObject:@"Second"];
    for (int i=0; i<=60; i++) {
        [arrSeconds addObject:[NSString stringWithFormat:@"%@%d",(i<10)?@"0":@"",i]];
    }
    _arrSecs = [NSArray arrayWithArray:arrSeconds];
    
    //Create array Hours
    NSMutableArray *arrHours = [[NSMutableArray alloc] initWithCapacity:12];
    [arrHours addObject:@"Hour"];
    for(int i=0; i<=12; i++) {
        [arrHours addObject:[NSString stringWithFormat:@"%@%d",(i<10) ? @"0":@"", i]];
    }
    _arrHours = [NSArray arrayWithArray:arrHours];
    
    //Create array Minutes
    NSMutableArray *arrMinutes = [[NSMutableArray alloc] initWithCapacity:60];
    [arrMinutes addObject:@"Minute"];
    for(int i=0; i<60; i++) {
        [arrMinutes addObject:[NSString stringWithFormat:@"%@%d",(i<10) ? @"0":@"", i]];
    }
    _arrMins = [NSArray arrayWithArray:arrMinutes];
    

}


- (void)buildControl {
    //Create a view as base of the picker
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0, self.frame.size.width, PICKER_HEIGHT)];
    [pickerView setBackgroundColor:self.backgroundColor];
    
    //Create bar selector
    UIView *barSel = [[UIView alloc] initWithFrame:CGRectMake(0.0, BAR_SEL_ORIGIN_Y, self.frame.size.width, VALUE_HEIGHT)];
    [barSel setBackgroundColor:BAR_SEL_COLOR];
    
    
    //Create the second column (hours) of the picker
    _dlHours = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, DL_HOURS_WIDTH, PICKER_HEIGHT) andValues:_arrHours withTextAlign:NSTextAlignmentCenter  andTextSize:PICKER_TEXT_SIZE];
    _dlHours.tag = 1;
    [_dlHours setDelegate:self];
    [_dlHours setDataSource:self];
    
    //Create the third column (minutes) of the picker
    _dlMins = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_dlHours.frame.origin.x+DL_HOURS_WIDTH, 0.0, DL_MINUTES_WIDTH, PICKER_HEIGHT) andValues:_arrMins withTextAlign:NSTextAlignmentCenter andTextSize:PICKER_TEXT_SIZE];
    _dlMins.tag = 2;
    [_dlMins setDelegate:self];
    [_dlMins setDataSource:self];
    
    //Create the fourth column (meridians) of the picker
    _dlSecs = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_dlMins.frame.origin.x+DL_MINUTES_WIDTH, 0.0, DL_SECS_WIDTH, PICKER_HEIGHT) andValues:_arrSecs withTextAlign:NSTextAlignmentLeft andTextSize:PICKER_TEXT_SIZE];
    _dlSecs.tag = 3;
    [_dlSecs setDelegate:self];
    [_dlSecs setDataSource:self];
    
    
    //Create separators lines
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(_dlHours.frame.origin.x+DL_HOURS_WIDTH-1.0, 0.0, 2.0, PICKER_HEIGHT)];
    [line2 setBackgroundColor:LINE_COLOR];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(_dlMins.frame.origin.x+DL_MINUTES_WIDTH-1.0, 0.0, 2.0, PICKER_HEIGHT)];
    [line3 setBackgroundColor:LINE_COLOR];
    
    
    //Layer gradient
    CAGradientLayer *gradientLayerTop = [CAGradientLayer layer];
    gradientLayerTop.frame = CGRectMake(0.0, 0.0, pickerView.frame.size.width, PICKER_HEIGHT/2.0);
    gradientLayerTop.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)self.backgroundColor.CGColor, nil];
    gradientLayerTop.startPoint = CGPointMake(0.0f, 0.7f);
    gradientLayerTop.endPoint = CGPointMake(0.0f, 0.0f);
    
    CAGradientLayer *gradientLayerBottom = [CAGradientLayer layer];
    gradientLayerBottom.frame = CGRectMake(0.0, PICKER_HEIGHT/2.0, pickerView.frame.size.width, PICKER_HEIGHT/2.0);
    gradientLayerBottom.colors = gradientLayerTop.colors;
    gradientLayerBottom.startPoint = CGPointMake(0.0f, 0.3f);
    gradientLayerBottom.endPoint = CGPointMake(0.0f, 1.0f);
    
    //Check if requires save area
    if (self.hasSavedArea) {
        [self createSaveArea];
    }
    
    //Add pickerView
    [self addSubview:pickerView];
    
    //Add separator lines
    [pickerView addSubview:line2];
    [pickerView addSubview:line3];
    
    //Add the bar selector
    [pickerView addSubview:barSel];
    
    //Add scrollViews
    [pickerView addSubview:_dlHours];
    [pickerView addSubview:_dlMins];
    [pickerView addSubview:_dlSecs];
    
    //Add gradients
    [pickerView.layer addSublayer:gradientLayerTop];
    [pickerView.layer addSublayer:gradientLayerBottom];
    
    //Add Savearea
    [self addSubview:saveArea];
    
    [self setUserInteractionEnabled:YES];
}

-(void)createSaveArea{
    //Create save area
    saveArea = [[UIView alloc] initWithFrame:CGRectMake(0.0, SAVE_AREA_ORIGIN_Y, self.frame.size.width, SAVE_AREA_HEIGHT)];
    [saveArea setBackgroundColor:SAVE_AREA_COLOR];
    
    //Create save button
    _delayButton = [[MGPickerButton alloc] initWithFrame:CGRectMake(5.0, 10.0, (self.frame.size.width-20.0)/2, SAVE_AREA_HEIGHT-20.0)];
    [_delayButton setTitle:@"Delay Now" forState:UIControlStateNormal];
    [_delayButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _cancelButton = [[MGPickerButton alloc] initWithFrame:CGRectMake(_delayButton.frame.origin.x+_delayButton.frame.size.width+10, 10.0, _delayButton.frame.size.width, _delayButton.frame.size.height)];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelSelection:) forControlEvents:UIControlEventTouchUpInside];
    
    //Add button save
    [saveArea addSubview:_delayButton];
    [saveArea addSubview:_cancelButton];

}

#pragma mark - Other methods

//Delay button pressed
- (void)saveButtonPressed:(id)sender {
    //Create date
    long secs = [self returnSecondsFromSelectedComponents];
    
    //Send the date to the delegate
    if([_delegate respondsToSelector:@selector(dataPicker:returnedSeconds:)]){
        [_delegate dataPicker:self returnedSeconds:secs];
    }
    
}

//Cancel button pressed
-(void)cancelSelection:(id)sender{
    if ([_delegate respondsToSelector:@selector(removeView)]) {
        [_delegate removeView];
    }
}


//Center the value in the bar selector
- (void)centerValueForScrollView:(MGPickerScrollView *)scrollView {
    
    //Takes the actual offset
    float offset = scrollView.contentOffset.y;
    
    //Removes the contentInset and calculates the prcise value to center the nearest cell
    offset += scrollView.contentInset.top;
    int mod = (int)offset%(int)VALUE_HEIGHT;
    float newValue = (mod >= VALUE_HEIGHT/2.0) ? offset+(VALUE_HEIGHT-mod) : offset-mod;
    
    //Calculates the indexPath of the cell and set it in the object as property
    NSInteger indexPathRow = (int)(newValue/VALUE_HEIGHT);
    
    //Center the cell
    [self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
}

//Center physically the cell
- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(MGPickerScrollView *)scrollView {
    
    if(indexPathRow >= [scrollView.arrValues count]) {
        indexPathRow = [scrollView.arrValues count]-1;
    }
    
    float newOffset = indexPathRow*VALUE_HEIGHT;
    
    //Re-add the contentInset and set the new offset
    newOffset -= BAR_SEL_ORIGIN_Y;
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        
        if (![_dlMins isScrolling] && ![_dlHours isScrolling] && ![_dlSecs isScrolling]) {
            [_delayButton setEnabled:YES];

        }
        
        //Highlight the cell
        [scrollView highlightCellWithIndexPathRow:indexPathRow];
        
        [scrollView setUserInteractionEnabled:YES];
        [scrollView setAlpha:1.0];
    }];
    
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
    
    [CATransaction commit];
    
}

//Return secs from a string

-(long)returnSecondsFromSelectedComponents{
    long hourRate = [_arrHours[_dlHours.tagLastSelected] intValue]*3600;
    long minRate = [_arrMins[_dlMins.tagLastSelected]intValue]*60;
    long secRate = [_arrSecs[_dlSecs.tagLastSelected]intValue];
    return hourRate + minRate + secRate ;
}


//Check the screen size
- (void)checkScreenSize {
    PICKER_HEIGHT = self.bounds.size.height;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (![scrollView isDragging]) {
        NSLog(@"didEndDragging");
        [(MGPickerScrollView *)scrollView setScrolling:NO];
        [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"didEndDecelerating");
    [(MGPickerScrollView *)scrollView setScrolling:NO];
    [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [_delayButton setEnabled:NO];
    
    MGPickerScrollView *sv = (MGPickerScrollView *)scrollView;
    [sv setScrolling:YES];
    [sv dehighlightLastCell];
}

#pragma - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    return [sv.arrValues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"reusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setFont:sv.cellFont];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setTextColor:(indexPath.row == sv.tagLastSelected) ? SELECTED_TEXT_COLOR : TEXT_COLOR];
    [cell.textLabel setText:sv.arrValues[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VALUE_HEIGHT;
}

@end
