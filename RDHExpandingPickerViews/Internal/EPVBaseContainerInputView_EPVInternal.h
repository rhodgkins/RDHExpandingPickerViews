//
//  EPVBaseContainerInputView_EPVInternal.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVBaseContainerInputView.h"

@interface EPVBaseContainerInputView ()

#pragma mark - Exposed base class methods

-(void)commonInit;

-(void)updateValueDisplay;

/// The `UIPicker` or `UIDatePicker` input view
@property (nonatomic, weak, readonly) UIView *pickerView;

#pragma mark - Required subclass methods

/// @returns The backing picker view.
-(UIView *)createPickerView;

-(NSString *)displayValueForSelectedObject;

#pragma mark - Optional subclass methods

/// @returns Default implemention returns `nil`.
-(NSAttributedString *)attributedDisplayValueForSelectedObject;

#pragma mark - Object selection

/// The selected object, a `NSDate` for date pickers or `NSArray` of selected row components for normal pickers.
@property (nonatomic, copy) id selectedObject;

/**
 * @param selectedObject The same as `selectedObject`.
 * @param animated `YES` to animate.
 *
 * @see `selectedObject`
 */
-(void)setSelectedObject:(id)selectedObject animated:(BOOL)animated;

/// Inital object for `selectedObject`.
@property (nonatomic, weak, readonly) id initiallySelectedObject;

@end
