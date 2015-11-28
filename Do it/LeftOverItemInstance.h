//
//  LeftOverItemInstance.h
//  Do it
//
//  Created by Jackie Chung on 18/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftOverItemInstance : NSObject

@property (nonatomic) NSInteger accumulatingDays;

@property (strong,nonatomic) NSString* content;

-(instancetype)initWithContent:(NSString*)content;

-(void)accumulate;

-(void)decumulate;

@end
