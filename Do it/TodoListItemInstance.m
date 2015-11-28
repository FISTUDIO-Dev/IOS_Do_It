//
//  TodoListItemInstance.m
//  Do it
//
//  Created by Jackie Chung on 18/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "TodoListItemInstance.h"

@implementation TodoListItemInstance


-(instancetype)init{
    
    [NSException raise:@"Use designated initializer" format:@"Initialize instance with content"];
    
    return nil;
    
}

-(instancetype)initWithContent:(NSString *)content{
    
    if (self = [super init]) {
        
        self.content = content;
        
        self.isCompleted = NO;
    }
    
    return self;
    
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"Normal todo list item with content %@", self.content];
}


@end
