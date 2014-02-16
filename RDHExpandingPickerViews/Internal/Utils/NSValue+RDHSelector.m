//
//  NSValue+RDHSelector.m
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "NSValue+RDHSelector.h"

@implementation NSValue (RDHSelector)

+(instancetype)valueWithSelector:(SEL)aSelector
{
    return [NSValue valueWithBytes:&aSelector objCType:@encode(SEL)];
}

-(SEL)selector
{
    SEL selector;
    [self getValue:&selector];
    return selector;
}

@end
