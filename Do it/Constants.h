//
//  Constants.h
//  Do it
//
//  Created by Jackie Chung on 9/07/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Font names */
static NSString* const kSF_FONT_REGULAR = @"SF-UI-Display-Regular.otf";
static NSString* const kSF_FONT_MEDIUM = @"SF-UI-Display-Medium.otf";
static NSString* const kSF_FONT_LIGHT = @"SF-UI-Display-Light.otf";

/* Notification names */
static NSString* const kNOTIF_ACTIVATE_FOCUS_MODE = @"notif_activate_focus_mode";
static NSString* const kNOTIF_DEACTIVATE_FOCUS_MODE = @"notif_deactivate_focus_mode";

static NSString* const kNOTIF_UPDATE_ACTIVITY_TABLE_VIEW = @"notif_updateTableViewData";
static NSString* const kNOTIF_PRESENT_RETRY_TIME_SELECTION_ACTION_SHEET = @"notif_presentRetryTimePickerActionSheet";

static NSString* const kNOTIF_ONGOING_ACTIVITY_COMPLETE_PRESSED = @"notif_complete_btn_pressed";

static NSString* const kNOTIF_EC_INTRO_VIEW_CANCELLING = @"notif_intro_view_cancelling";
static NSString* const kNOTIF_EC_INTRO_VIEW_PROCEEDING = @"notif_intro_view_proc";
static NSString* const kNOTIF_EC_TASK_VIEW_PROCEEDING = @"notif_task_view_proc";
static NSString* const kNOTIF_EC_TIME_PICKER_PROCEEDING = @"notif_time_picker_proc";
static NSString* const kNOTIF_EC_FINAL_FINISH = @"notif_final_finish";

static NSString* const kNOTIF_NORMAL_LIST_REQUEST_DAILY_AT_INDEX = @"notif_normal_list_request_daily";
static NSString* const kNOTIF_NORMAL_LIST_SET_COMPLETED = @"notif_normal_list_set_completed";
static NSString* const kNOTIF_REDUNDANT_LIST_SET_COMPLETED = @"notif_redundant_list_set_completed";
static NSString* const kNOTIF_DAILT_LIST_CANCEL_DAILY = @"notif_daily_list_cancel_daily";
static NSString* const kNOTIF_DAILY_LIST_SET_COMPLETED = @"notif_daily_list_set_completed";
static NSString* const kNOTIF_DAILY_LIST_PRESENT_SET_REMINDER = @"notif_daily_list_present_reminder";

/* LocalNotification to LNNotification User Info Keys */
static NSString* const kLOCAL_IN_APP_NOTIF_INFO_TRIGGERING_ACTION_KEY = @"local_notif_triggering_action_key";
static NSString* const kLOCAL_IN_APP_NOTIF_INFO_IMAGE_NAME_KEY = @"local_notif_image_name_key";

/* Activity Dictionary Save Keys */
static NSString* const kACTIVITY_DICTIONARY_ONGOING = @"activity_dictionary_ongoing";
static NSString* const kACTIVITY_DICTIONARY_ACHIEVEMENT = @"activity_dictionary_achievement";
static NSString* const kACTIVITY_DICTIONARY_FAIL = @"activity_dictionary_failures";
static NSString* const kACTIVITY_DICTIONARY_NORMAL_LIST = @"activity_dictionary_normallist";
static NSString* const kACTIVITY_DICTIONARY_DAILY_ROUTINE = @"activity_dictionary_dailyroutine";
static NSString* const kACTIVITY_DICTIONARY_REDUNDANCY = @"activity_dictionary_redundancy";

static NSString* const kDAILY_NOTIFICATION_TO_BE_CANCELLED_KEY = @"daily_notification_to_be_cancelled";

