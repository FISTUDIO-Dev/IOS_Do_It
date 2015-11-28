//
//  LeftOverItemInstance.m
//  Do it
//
//  Created by Jackie Chung on 18/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "LeftOverItemInstance.h"

@implementation LeftOverItemInstance



-(instancetype)init {
    
    [NSException raise:@"Use designated initializer" format:@"Initialize with content"];
    
    return nil;
    
}


-(instancetype)initWithContent:(NSString *)content {
    
    if (self = [super init]) {
        
        self.content = content;
        
        self.accumulatingDays = 0;
        
    }
    
    return self;
    
}

-(void)accumulate{
    
    self.accumulatingDays ++;
    
}


-(void)decumulate {
    
    self.accumulatingDays --;
    
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"Left over item with content %@", self.content];
}


@end
