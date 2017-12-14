//
//  NSArray+RDHFill.h
//
//  Created by Richard Hodgkins on 16/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (RDHFill)

+(instancetype)arrayFilledWithCount:(NSUInteger)count ofObject:(id)object;

@end

NS_ASSUME_NONNULL_END
