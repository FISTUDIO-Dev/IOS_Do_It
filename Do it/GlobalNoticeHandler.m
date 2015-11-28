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
#import "SCLAlertView.h"


@interface GlobalNoticeHandler()

@end

@implementation GlobalNoticeHandler


/**
 
 * @brief  Create basic informational alert
 
 * @param  Title , Description , btnText
 
 * @return UIAlertView
 
 */
+(void)createInformationalAlertViewWithTitle:(NSString *)title Description:(NSString *)description ButtonText:(NSString *)btnText{
    UIAlertView * infoAlert = [[UIAlertView alloc]initWithTitle:title message:description delegate:self cancelButtonTitle:btnText otherButtonTitles:nil, nil];
    [infoAlert show];
}

/**
 
 * @brief   Create HUD with configuration
 
 * @param   Title , Duration , isSuccess , isInteractive , Callback
 
 * @return  ProgressHUD
 
 */
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


+(void)showIndicativeAlertInController:(UIViewController *)controller WithTitle:(NSString *)title Subtitle:(NSString *)subtitle Closebuttontitle:(NSString *)cbtitle AlertType:(DIAlertTypes)type Duration:(NSTimeInterval)interval{
    
    //Create alert instance
    
    SCLAlertView * indiAlert = [[SCLAlertView alloc]init];
    
    switch (type) {
            
        case DIALERT_SUCCESS:{
            
            [indiAlert showSuccess:controller title:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval];
            
        }
            break;
        case DIALERT_ERROR:{
            [indiAlert showError:controller title:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval];
        }
            
            break;
        case DIALERT_INFO:{
            [indiAlert showInfo:controller title:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval];
        }
            
            break;
        case DIALERT_NOTICE:{
            [indiAlert showNotice:controller title:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval];
        }
            
            break;
            
        case DIALERT_WARNING:{
            [indiAlert showWarning:controller title:title subTitle:subtitle closeButtonTitle:cbtitle duration:interval];
            
        }
            
            break;
            
        default:
            
            break;
    }
}

/**
 
 * @brief   Show alert that looks like notification
 
 * @param   Message , Duration , Banner Type , Completion Block
 
 * @return  Alert ( a notification plugin )
 
 */

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

/**
 
 * @brief   Show alert that looks like native iOS notification
 
 * @param   Title , Message , Duration , Image Name as an icon , Completion method on tapping
 
 * @return  HDNotification
 
 */

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
