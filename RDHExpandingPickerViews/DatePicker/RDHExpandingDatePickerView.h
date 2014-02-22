//
//  RDHExpandingDatePickerView.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "_RDHBaseExpandingPickerContainerView.h"

/// Expanding picker view backed by a `UIDatePicker`.
@interface RDHExpandingDatePickerView : _RDHBaseExpandingPickerContainerView

/// The backing data picker.
@property (nonatomic, weak, readonly) UIDatePicker *pickerView;

#pragma mark - Date selection
/// @name Date selection

/// The selected `NSDate`.
@property (nonatomic, copy) NSDate *selectedDate;

/// @see selectedDate
-(void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated;

#pragma mark - Countdown time selection
/// @name Countdown time selection

/// The selected `NSTimeInterval`.
@property (nonatomic, assign) NSTimeInterval selectedTimeInterval;

/// @see selectedTimeInterval
-(void)setSelectedTimeInterval:(NSTimeInterval)selectedTimeInterval animated:(BOOL)animated;

#pragma mark - Date display
/// @name Date display

/**
 * This will be used to display the `selectedObject` date when the `pickerView` is **not** in `UIDatePickerModeCountDownTimer` mode. This is ignored if `displayValueBlock` or `attriburedDisplayValueBlock` is set.
 *
 * If this property or the other two block properties are not set the `[NSDateFormatter localizedStringFromDate:dateStyle:timeStyle:]` with the date and time style depending on the picker mode.
 */
@property (nonatomic, copy) NSDateFormatter *dateFormatter;

#pragma mark - Display blocks
/// @name Display blocks

/// This will be ignored if `attributedDisplayValueBlock` is set or returns `nil`.
@property (nonatomic, copy) NSString*(^displayValueBlock)(RDHExpandingDatePickerView *expandingPickerView, NSDate *selectedObject);

/// This will be used first, followed by `displayValueBlock` and then the `dateFormatter`.
@property (nonatomic, copy) NSAttributedString*(^attributedDisplayValueBlock)(RDHExpandingDatePickerView *expandingPickerView, NSDate *selectedObject);

@end
