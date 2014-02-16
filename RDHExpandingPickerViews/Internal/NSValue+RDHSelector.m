//
//  NSValue+RDHSelector.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "NSValue+RDHSelector.h"

@implementation NSValue (RDHSelector)

+(instancetype)valueWithSelector:(SEL)selector
{
    return [NSValue valueWithBytes:&selector objCType:@encode(SEL)];
}

-(SEL)selector
{
    SEL selector;
    [self getValue:&selector];
    return selector;
}

@end
