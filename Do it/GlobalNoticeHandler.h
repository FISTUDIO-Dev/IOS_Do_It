//
//  GlobalNoticeHandler.h
//  Do it
//
//  Created by Jackie Chung on 24/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//Indicator alert types
typedef NS_ENUM(NSInteger, DIAlertTypes) {
    DIALERT_SUCCESS,
    DIALERT_ERROR,
    DIALERT_NOTICE,
    DIALERT_WARNING,
    DIALERT_INFO
};
//Banner alert types
typedef NS_ENUM(NSInteger, DNBannerTypes) {
    DNBANNER_SUCCESS,
    DNBANNER_WARNING,
    DNBANNER_ERROR
};

@interface GlobalNoticeHandler : NSObject

//Short alert with button
+(void)createInformationalAlertViewWithTitle:(NSString*)title Description:(NSString*)description ButtonText:(NSString*)btnText;

//HUD without button
+(void)showHUDWithText:(NSString*)title ForPeriod:(CGFloat)time Success:(BOOL)isSuccess Interactive:(BOOL)isinteractive Callback:(void (^)())callback;

//Indicator alert with close button
+(void)showIndicativeAlertWithTitle:(NSString*)title Subtitle:(NSString*)subtitle Closebuttontitle:(NSString*)cbtitle AlertType:(DIAlertTypes)type Duration:(NSTimeInterval)interval;

//Notification Alert
+(void)showNotificationAlertWithMessage:(NSString*)message Duration:(CGFloat)duration Type:(DNBannerTypes)type Completion:(void(^)())completion;

+(void)showNotificationBannerWithTitle:(NSString*)title Message:(NSString*)message Duration:(CGFloat)duration ImageName:(NSString*)imagename OnTapCompletion:(void(^)())completion;
@end
