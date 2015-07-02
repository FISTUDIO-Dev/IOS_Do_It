//
//  GlobalNoticeHandler.m
//  Do it
//
//  Created by Jackie Chung on 24/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import "GlobalNoticeHandler.h"

@interface GlobalNoticeHandler() {
    
}

@end

@implementation GlobalNoticeHandler

+(void)createInformationalAlertViewWithTitle:(NSString *)title Description:(NSString *)description ButtonText:(NSString *)btnText{
    UIAlertView * infoAlert = [[UIAlertView alloc]initWithTitle:title message:description delegate:self cancelButtonTitle:btnText otherButtonTitles:nil, nil];
    [infoAlert show];
}

@end
