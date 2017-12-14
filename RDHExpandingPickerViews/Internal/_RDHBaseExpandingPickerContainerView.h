//
//  _RDHBaseExpandingPickerContainerView.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// @name Constants

/// Activated == Expanded
UIKIT_EXTERN const UIControlState RDHControlStateActivated;

#pragma mark - Picker heights

/// Picker view heights
typedef CGFloat RDHPickerViewHeight;

/// 162 pts
UIKIT_EXTERN const RDHPickerViewHeight RDHPickerViewHeightShortest;
/// 180 pts
UIKIT_EXTERN const RDHPickerViewHeight RDHPickerViewHeightStandard;
/// 216 pts
UIKIT_EXTERN const RDHPickerViewHeight RDHPickerViewHeightHighest;

/**
 * Base class which controls the displaying and showing of the subclasses pickerView.
 * 
 * ### Control Events ###
 *
 * `UIControlEventEditingDidBegin` when the expanded picker view becomes first responder.
 *
 * `UIControlEventEditingDidEnd` when the expanded picker view resigns first responder.
 *
 * `UIControlEventValueChanged` when the selection changes in the picker by user action. Check `selectedObject` for the new value.
 *
 * ### Control States ###
 *
 * `UIControlStateNormal` when there is no value selected in the picker.
 *
 * `UIControlStateSelected` when a value has been selected from the picker, or set manually.
 *
 * `RDHControlStateActivated` when the control is expanded showing the picker.
 *
 */
@interface _RDHBaseExpandingPickerContainerView : UIControl

#pragma mark - Layout configuration
/// @name Layout configuration

/// Height of the view when not expanded.
@property (nonatomic, assign) CGFloat displayHeight;

/// Size of the picker view when expanded. Default value is `RDHPickerViewHeightStandard`.
@property (nonatomic, assign) RDHPickerViewHeight pickerViewHeight;

/// Insets for the labels (both the `titleLabel` and `valueLabel`). The left value will be used for the `titleLabel` and the right for the `valueLabel`. Default value is `UIEdgeInsetsZero`.
@property (nonatomic, assign) UIEdgeInsets labelEdgeInsets;

#pragma mark - Activated state
/// @name Activated state

@property (nonatomic, assign, getter = isActivated) BOOL activated;

-(void)setActivated:(BOOL)activated animated:(BOOL)animated;

@end

///
@interface _RDHBaseExpandingPickerContainerView (RDHStateDisplay)

+(void)setUseDefaultColorStates:(BOOL)useDefaultStates;

#pragma mark - Label background color
/// @name Label background color

-(void)setLabelBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR;                     // default is transparent black.

-(UIColor *)labelBackgroundColorForState:(UIControlState)state;          // these getters only take a single state value

@property (nonatomic, readonly, strong, nullable) UIColor *currentLabelBackgroundColor;  // normal/highlighted/selected/disabled. can return nil

#pragma mark - Title display
/// @name Title display

@property (nonatomic, strong, null_resettable) UIFont *titleFont;

// you can set the image, title color, title shadow color, and background image to use for each state. you can specify data
// for a combined state by using the flags added together. in general, you should specify a value for the normal state to be used
// by other states which don't have a custom value set

-(void)setTitle:(nullable NSString *)title forState:(UIControlState)state;                     // default is nil. title is assumed to be single line
-(void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default if nil. use opaque white
-(void)setTitleShadowColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default is nil. use 50% black
-(void)setAttributedTitle:(nullable NSAttributedString *)title forState:(UIControlState)state; // default is nil. title is assumed to be single line

-(nullable NSString *)titleForState:(UIControlState)state;          // these getters only take a single state value
-(nullable UIColor *)titleColorForState:(UIControlState)state;
-(nullable UIColor *)titleShadowColorForState:(UIControlState)state;
-(nullable NSAttributedString *)attributedTitleForState:(UIControlState)state;

// these are the values that will be used for the current state. you can also use these for overrides. a heuristic will be used to
// determine what image to choose based on the explict states set. For example, the 'normal' state value will be used for all states
// that don't have their own image defined.

@property(nonatomic, readonly, strong, nullable) NSString *currentTitle;             // normal/highlighted/selected/disabled. can return nil
@property(nonatomic, readonly, strong, nullable) UIColor  *currentTitleColor;        // normal/highlighted/selected/disabled. always returns non-nil. default is white(1,1)
@property(nonatomic, readonly, strong, nullable) UIColor  *currentTitleShadowColor;  // normal/highlighted/selected/disabled. default is white(0,0.5).
@property(nonatomic, readonly, strong, nullable) NSAttributedString *currentAttributedTitle;  // normal/highlighted/selected/disabled. can return nil

/// The title label itself, this should **not** be used for setting the font, text value, attributed text value, text color or shadow color.
@property (nonatomic, assign, readonly) UILabel *titleLabel;

#pragma mark - Value display
/// @name Value display

/// Placeholder text for when no value is selected - states normal, normal/highlighted, normal/highlighted/activated, normal/activated
@property (nonatomic, copy, nullable) NSString *placeholderValue;

/// Attributed placeholder text for when no value is selected - states normal, normal/highlighted, normal/highlighted/activated, normal/activated
@property (nonatomic, copy, nullable) NSAttributedString *attributedPlaceholderValue;

/// Placeholder text color for when no value is selected - states normal, normal/highlighted, normal/highlighted/activated, normal/activated
@property (nonatomic, strong, nullable) UIColor *placeholderValueColor;

@property (nonatomic, strong, null_resettable) UIFont *valueFont;

-(void)setValueColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default if nil. use opaque white
-(void)setValueShadowColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default is nil. use 50% black

-(nullable UIColor *)valueColorForState:(UIControlState)state;
-(nullable UIColor *)valueShadowColorForState:(UIControlState)state;

@property(nonatomic, readonly, strong, nullable) UIColor  *currentValueColor;        // normal/highlighted/selected/disabled. default is white(1,1)
@property(nonatomic, readonly, strong, nullable) UIColor  *currentValueShadowColor;  // normal/highlighted/selected/disabled. default is white(0,0.5).

/// The value label itself, this should **not** be used for setting the font, text value, attributed text value, text color or shadow color.
@property (nonatomic, weak, readonly) UILabel *valueLabel;

@end

@interface _RDHBaseExpandingPickerContainerView (RDHPickerDisplay)

#pragma mark - Picker background
/// @name Picker background

/// The default value is `[UIColor clearColor]`
@property (nonatomic, strong, null_resettable) UIColor *pickerViewBackgroundColor;

@end

NS_ASSUME_NONNULL_END
