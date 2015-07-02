//
//  GlobalNoticeHandler.h
//  Do it
//
//  Created by Jackie Chung on 24/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalNoticeHandler : NSObject

//Short Alerts
+(void)createInformationalAlertViewWithTitle:(NSString*)title Description:(NSString*)description ButtonText:(NSString*)btnText;

@end
