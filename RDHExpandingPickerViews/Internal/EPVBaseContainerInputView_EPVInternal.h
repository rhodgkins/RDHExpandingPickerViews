//
//  EPVBaseContainerInputView_EPVInternal.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVBaseContainerInputView.h"

#ifdef DEBUG2
#   define DEBUG_COLOR(V, C) ((V).backgroundColor = [UIColor C])
#else
#   define DEBUG_COLOR(V, C)
#endif

@interface EPVBaseContainerInputView ()

-(void)commonInit;

-(void)updateValueDisplay;

/// The `UIPicker` or `UIDatePicker` input view
@property (nonatomic, weak, readonly) UIView *pickerView;

#pragma mark - Required subclass methods

-(UIView *)createPickerView;

-(NSString *)displayValueForSelectedObject;

#pragma mark - Optional subclass methods

/// @returns Default implemention returns `nil`.
-(NSAttributedString *)attributedDisplayValueForSelectedObject;

#pragma mark - Object selection

/// The selected object, a `NSDate` for date pickers or `NSArray` of selected row components for normal pickers.
@property (nonatomic, copy) id selectedObject;

-(void)setSelectedObject:(id)selectedObject animated:(BOOL)animated;

/// Inital object for `selectedObject`.
@property (nonatomic, weak, readonly) id initiallySelectedObject;

@end
