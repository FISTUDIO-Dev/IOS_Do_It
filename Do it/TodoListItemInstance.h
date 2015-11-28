//
//  TodoListItemInstance.h
//  Do it
//
//  Created by Jackie Chung on 18/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoListItemInstance : NSObject


@property (strong,nonatomic) NSString* content;

@property (assign,nonatomic) BOOL isCompleted;

-(instancetype)initWithContent:(NSString*)content;

@end
