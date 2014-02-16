//
//  NSValue+RDHSelector.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (RDHSelector)

+(instancetype)valueWithSelector:(SEL)selector;

-(SEL)selector;

@end
