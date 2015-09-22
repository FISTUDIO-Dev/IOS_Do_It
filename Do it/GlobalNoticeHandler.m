//
//  GlobalNoticeHandler.m
//  Do it
//
//  Created by Jackie Chung on 24/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "GlobalNoticeHandler.h"
#import "ProgressHUD.h"
#import "Alert.h"
#import "HDNotificationView.h"
#import "Do_it-Swift.h"
//indicator alert styles
static const NSUInteger DIALERT_TINT_SUCCESS = 0x22B573;
static const NSUInteger DIALERT_TINT_ERROR = 0xC1272D;
static const NSUInteger DIALERT_TINT_NOTICE = 0x727375;
static const NSUInteger DIALERT_TINT_WARNING = 0xFFD110;
static const NSUInteger DIALERT_TINT_INFO = 0x2866BF;
static const NSUInteger DIALERT_BTN_WHITE = 0xFFFFFF;
static const NSUInteger DIALERT_BTN_BLACK = 0x000000;

@interface GlobalNoticeHandler()

@end

@implementation GlobalNoticeHandler

+(void)createInformationalAlertViewWithTitle:(NSString *)title Description:(NSString *)description ButtonText:(NSString *)btnText{
    UIAlertView * infoAlert = [[UIAlertView alloc]initWithTitle:title message:description delegate:self cancelButtonTitle:btnText otherButtonTitles:nil, nil];
    [infoAlert show];
}


+(void)showHUDWithText:(NSString*)title ForPeriod:(CGFloat)time Success:(BOOL)isSuccess Interactive:(BOOL)isinteractive Callback:(void (^)())callback{
    //Show the HUD
    if (isSuccess) {
        [ProgressHUD showSuccess:title Interaction:isinteractive];
    }else if (!isSuccess){
        [ProgressHUD showError:title Interaction:isinteractive];
    }else{
        [ProgressHUD show:title];
    }
    
    //Dismiss it later
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [ProgressHUD dismiss];
    });
    
    //Tigger callback
    if (callback != nil) {
        callback();
    }
}

+(void)showIndicativeAlertWithTitle:(NSString*)title Subtitle:(NSString*)subtitle Closebuttontitle:(NSString*)cbtitle AlertType:(DIAlertTypes)type Duration:(NSTimeInterval)interval{
    //Create alert instance
    SCLAlertView * indiAlert = [[SCLAlertView alloc]init];
    switch (type) {
        case DIALERT_SUCCESS:{
            
            [indiAlert showSuccess:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval colorStyle:DIALERT_TINT_SUCCESS colorTextButton:DIALERT_BTN_WHITE];
            
        }
            break;
        case DIALERT_ERROR:{
            [indiAlert showError:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval colorStyle:DIALERT_TINT_ERROR colorTextButton:DIALERT_BTN_WHITE];
        }
            
            break;
        case DIALERT_INFO:{
            [indiAlert showInfo:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval colorStyle:DIALERT_TINT_INFO colorTextButton:DIALERT_BTN_WHITE];
        }
            
            break;
        case DIALERT_NOTICE:{
            [indiAlert showNotice:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval colorStyle:DIALERT_TINT_NOTICE colorTextButton:DIALERT_BTN_WHITE];
        }
            
            break;
            
        case DIALERT_WARNING:{
            [indiAlert showWarning:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval colorStyle:DIALERT_TINT_WARNING colorTextButton:DIALERT_BTN_BLACK];
        }
            
            break;
        default:
            break;
    }
}

+(void)showNotificationAlertWithMessage:(NSString *)message Duration:(CGFloat)duration Type:(DNBannerTypes)type Completion:(void (^)())completion{
    Alert* alert = [[Alert alloc]initWithTitle:message duration:duration completion:completion];
    switch (type) {
        case DNBANNER_SUCCESS:
            [alert setAlertType:AlertTypeSuccess];
            break;
        case DNBANNER_ERROR:
            [alert setAlertType:AlertTypeError];
            break;
        case DNBANNER_WARNING:
            [alert setAlertType:AlertTypeWarning];
            break;
        default:
            break;
    }
    [alert setIncomingTransition:AlertIncomingTransitionTypeSlideFromTop];
    [alert setOutgoingTransition:AlertOutgoingTransitionTypeSlideToTop];
    [alert setShowStatusBar:NO];
    [alert setBounces:YES];
    
    [alert showAlert];
}

+(void)showNotificationBannerWithTitle:(NSString *)title Message:(NSString *)message Duration:(CGFloat)duration ImageName:(NSString *)imagename OnTapCompletion:(void (^)())completion{
    if (duration == 0) {
        //autohide
        [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:imagename] title:title message:message isAutoHide:YES onTouch:^(void){
            [HDNotificationView hideNotificationViewOnComplete:completion];
        }];
    }else{
        [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:imagename] title:title message:message isAutoHide:NO onTouch:^(void){
            [HDNotificationView hideNotificationViewOnComplete:completion];
        }];
        //Dismiss it after an amount of time
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HDNotificationView hideNotificationViewOnComplete:nil];
        });
    }
}


@end
