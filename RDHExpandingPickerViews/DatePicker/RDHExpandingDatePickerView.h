//
//  RDHExpandingDatePickerView.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "_RDHBaseExpandingPickerContainerView.h"

NS_ASSUME_NONNULL_BEGIN

/// Expanding picker view backed by a `UIDatePicker`.
@interface RDHExpandingDatePickerView : _RDHBaseExpandingPickerContainerView

/// The backing data picker.
@property (nonatomic, assign, readonly) UIDatePicker *pickerView;

#pragma mark - Date selection
/// @name Date selection

/// The selected `NSDate`.
@property (nonatomic, copy, nullable) NSDate *selectedDate;

/// @see selectedDate
-(void)setSelectedDate:(nullable NSDate *)selectedDate animated:(BOOL)animated;

#pragma mark - Countdown time selection
/// @name Countdown time selection

/// The selected `NSTimeInterval`.
@property (nonatomic, assign) NSTimeInterval selectedTimeInterval;

/// @see selectedTimeInterval
-(void)setSelectedTimeInterval:(NSTimeInterval)selectedTimeInterval animated:(BOOL)animated;

#pragma mark - Date display
/// @name Date display

/**
 * This will be used to display the `selectedObject` date when the `pickerView` is **not** in `UIDatePickerModeCountDownTimer` mode. This is ignored if `setDateDisplayValueBlock:` if non-nil or `setDateDisplayValueBlock:` is non-nil.
 *
 * If this property or the other two block properties are not set the `[NSDateFormatter localizedStringFromDate:dateStyle:timeStyle:]` with the date and time style depending on the picker mode.
 */
@property (nonatomic, copy, nullable) NSDateFormatter *dateFormatter;

/// This will be ignored if the value passed into `setDateDisplayValueBlock:` is non-nil.
-(void)setDateDisplayValueBlock:(NSString* _Nullable (^_Nullable)(RDHExpandingDatePickerView * _Nonnull, NSDate * _Nonnull))block;

/// This will be used first, followed by the non-nil value passed into `setDateDisplayValueBlock:` and then the `dateFormatter`.
-(void)setAttributedDateDisplayValueBlock:(NSAttributedString * _Nullable (^_Nullable)(RDHExpandingDatePickerView * _Nonnull, NSDate * _Nonnull))block;

#pragma mark - Time interval display
/// @name Time interval display

/**
 * This will be used to display the `selectedObject` date when the `pickerView` **is** in `UIDatePickerModeCountDownTimer` mode. This is ignored if `setTimeIntervalDisplayValueBlock` is non-nil or `setAttributedTimeIntervalDisplayValueBlock:` is non-nil.
 *
 * If this property or the other two block properties are not set the format `H:m` of the current locale is used.
 *
 * The object passed into this formatter will be a `NSNumber` wrapping up the selected time interval.
 */
@property (nonatomic, copy, nullable) NSFormatter *timeIntervalFormatter;

/// This will be ignored if the value passed into `setAttributedTimeIntervalDisplayValueBlock:` is non-nil.
- (void)setTimeIntervalDisplayValueBlock:(NSString* _Nullable (^_Nullable)(RDHExpandingDatePickerView *expandingPickerView, NSTimeInterval selectedObject))block;

/// This will be used first, followed by the non-nil value passed into `setTimeIntervalDisplayValueBlock:` and then the `timeIntervalFormatter`.
-(void)setAttributedTimeIntervalDisplayValueBlock:(NSAttributedString * _Nullable (^_Nullable)(RDHExpandingDatePickerView * _Nonnull, NSTimeInterval))block;

@end

NS_ASSUME_NONNULL_END
