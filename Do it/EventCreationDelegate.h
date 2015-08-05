//
//  EventCreationDelegate.h
//  Do it
//
//  Created by Jackie Chung on 23/06/2015.
//  Copyright (c) 2015 Future Innovation Studio. All rights reserved.
//

@protocol EventCreationDelegate <NSObject>

@required
-(void)dismissEventCreationViewControllerWithData:(BOOL)haveData;

@end
