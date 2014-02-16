//
//  NSArray+RDHFill.m
//
//  Created by Richard Hodgkins on 16/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "NSArray+RDHFill.h"

@implementation NSArray (RDHFill)

+(instancetype)arrayFilledWithCount:(NSUInteger)count ofObject:(id)object
{
    id objects[count];
    for (NSUInteger i=0; i<count; i++) {
        objects[i] = object;
    }
    return [self arrayWithObjects:objects count:count];
}

@end
