//
//  ActivityTableViewCellController.h
//  Do it
//
//  Created by YINGGUANG CHEN on 15/6/6.
//  Copyright (c) 2015年 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityTableViewCellController : NSObject

//Construct Time Label for Ongong Activity
+(NSString*)timeLeftLabelTextFromTimeComponents:(NSDictionary*)timeComponents;

//Construct date text for Achievement cells
+(NSString*)formattedDateStringFromDate:(NSDate*)date;

//Construct remaining time text for Achievement cells
+(NSString*)remainingTimeTextFromTimeComponents:(NSDictionary*)timeComponents;
@end
