//
//  _RDHBaseExpandingPickerContainerView_RDHInternal.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "_RDHBaseExpandingPickerContainerView.h"

@interface _RDHBaseExpandingPickerContainerView ()

#pragma mark - Exposed base class methods

-(void)subclassCalled;

-(void)commonInit;

-(void)updateValueDisplay;

/// The `UIPicker` or `UIDatePicker` input view
@property (nonatomic, weak, readonly) UIView *pickerView;

#pragma mark - Required subclass methods

/// @returns The backing picker view.
-(UIView *)createPickerView;

#pragma mark - Optional subclass methods

/// @returns Default implementation returns `nil`.
-(id)initiallySelectedObject;

/// @returns Default implementation uses the `displayValueBlock`.
-(NSString *)defaultDisplayValueForSelectedObject;

/// @returns Default implemention returns `nil` if there is no `attriburedDisplayValueBlock` set.
-(NSAttributedString *)defaultAttributedDisplayValueForSelectedObject;

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

#pragma mark - Display blocks

@property (nonatomic, copy) NSString*(^displayValueBlock)(_RDHBaseExpandingPickerContainerView *expandingPickerView, id selectedObject);

@property (nonatomic, copy) NSAttributedString*(^attriburedDisplayValueBlock)(_RDHBaseExpandingPickerContainerView *expandingPickerView, id selectedObject);

@end
