//
//  NSValue+RDHSelector.h
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// NSValue wrapped for selectors.
@interface NSValue (RDHSelector)

/**
 * @param aSelector a selector.
 * @returns a wrapped selector.
 */
+(instancetype)valueWithSelector:(SEL)aSelector;

/// @returns the selector that this value was created with using `valueWithSelector:`.
-(SEL)selector;

@end

NS_ASSUME_NONNULL_END
