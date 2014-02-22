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

/// This will be used to display the `selectedObject` date when the `pickerView` is **not** in `UIDatePickerModeCountDownTimer` mode.
@property (nonatomic, copy) NSDateFormatter *dateFormatter;

#pragma mark - Display blocks
/// @name Display blocks

@property (nonatomic, copy) NSString*(^displayValueBlock)(RDHExpandingDatePickerView *expandingPickerView, NSDate *selectedObject);

@property (nonatomic, copy) NSAttributedString*(^attriburedDisplayValueBlock)(RDHExpandingDatePickerView *expandingPickerView, NSDate *selectedObject);

@end
