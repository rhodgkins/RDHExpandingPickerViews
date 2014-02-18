//
//  EPVBaseContainerInputView.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Activated == Expanded
UIKIT_EXTERN const UIControlState RDHControlStateActivated;

// Normal state == no item selected
// Selected state = item selected

/// Picker view heights
typedef CGFloat EPVPickerViewHeight;

/// 162 pts
UIKIT_EXTERN const EPVPickerViewHeight EPVPickerViewHeightShortest;
/// 180 pts
UIKIT_EXTERN const EPVPickerViewHeight EPVPickerViewHeightStandard;
/// 216 pts
UIKIT_EXTERN const EPVPickerViewHeight EPVPickerViewHeightHighest;

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
 */
@interface EPVBaseContainerInputView : UIControl

/// Height of the view when not expanded.
@property (nonatomic, assign) CGFloat displayHeight;

/// Background color for the normal state when this control has not been touched or is not expanded
//@property (nonatomic, strong) UIColor *displayBackgroundColor;
//
//@property (nonatomic, strong) UIColor *displayHighlightedBackgroundColor;
//
//@property (nonatomic, strong) UIColor *displayExpandedBackgroundColor;
//
//@property (nonatomic, strong) UIColor *displayExpandedHighlightedBackgroundColor;

/// Size of the picker view when expanded. Default value is `EPVPickerViewHeightStandard`.
@property (nonatomic, assign) EPVPickerViewHeight pickerViewHeight;

@property (nonatomic, strong) UIColor *pickerViewBackgroundColor;

/// Insets for the labels (both the `titleLabel` and `valueLabel`). The left value will be used for the `titleLabel` and the right for the `valueLabel`. Default value is `UIEdgeInsetsZero`.
@property (nonatomic, assign) UIEdgeInsets labelEdgeInsets;

#pragma mark - Title label display
/// @name Configuring the title label display

/// The label that shows what can be selected.
//@property (nonatomic, weak, readonly) UILabel *titleLabel;

@property (nonatomic, assign, getter = isActivated) BOOL activated;

@end

///
@interface EPVBaseContainerInputView (RDHStateDisplay)

#pragma mark - Label background color
/// @name Label background color

-(void)setLabelBackgroundColor:(UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR;                     // default is transparent black.

-(UIColor *)labelBackgroundColorForState:(UIControlState)state;          // these getters only take a single state value

@property (nonatomic, readonly, strong) UIColor *currentLabelBackgroundColor;  // normal/highlighted/selected/disabled. can return nil

#pragma mark - Title display
/// @name Title display

@property (nonatomic, strong) UIFont *titleFont;

// you can set the image, title color, title shadow color, and background image to use for each state. you can specify data
// for a combined state by using the flags added together. in general, you should specify a value for the normal state to be used
// by other states which don't have a custom value set

-(void)setTitle:(NSString *)title forState:(UIControlState)state;                     // default is nil. title is assumed to be single line
-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default if nil. use opaque white
-(void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default is nil. use 50% black
-(void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state; // default is nil. title is assumed to be single line

-(NSString *)titleForState:(UIControlState)state;          // these getters only take a single state value
-(UIColor *)titleColorForState:(UIControlState)state;
-(UIColor *)titleShadowColorForState:(UIControlState)state;
-(NSAttributedString *)attributedTitleForState:(UIControlState)state;

// these are the values that will be used for the current state. you can also use these for overrides. a heuristic will be used to
// determine what image to choose based on the explict states set. For example, the 'normal' state value will be used for all states
// that don't have their own image defined.

@property(nonatomic, readonly, strong) NSString *currentTitle;             // normal/highlighted/selected/disabled. can return nil
@property(nonatomic, readonly, strong) UIColor  *currentTitleColor;        // normal/highlighted/selected/disabled. always returns non-nil. default is white(1,1)
@property(nonatomic, readonly, strong) UIColor  *currentTitleShadowColor;  // normal/highlighted/selected/disabled. default is white(0,0.5).
@property(nonatomic, readonly, strong) NSAttributedString *currentAttributedTitle;  // normal/highlighted/selected/disabled. can return nil

/// The title label itself, this should **not** be used for setting the font, text value, attributed text value, text color or shadow color.
@property (nonatomic, weak, readonly) UILabel *titleLabel;

#pragma mark - Value display
/// @name Value display

/// Placeholder text for when no value is selected.
@property (nonatomic, copy) NSString *placeholderValue;

/// Attributed placeholder text for when no value is selected.
@property (nonatomic, copy) NSAttributedString *attributedPlaceholderValue;

@property (nonatomic, strong) UIFont *valueFont;

-(void)setValueColor:(UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default if nil. use opaque white
-(void)setValueShadowColor:(UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default is nil. use 50% black

-(UIColor *)valueColorForState:(UIControlState)state;
-(UIColor *)valueShadowColorForState:(UIControlState)state;

@property(nonatomic, readonly, strong) UIColor  *currentValueColor;        // normal/highlighted/selected/disabled. always returns non-nil. default is white(1,1)
@property(nonatomic, readonly, strong) UIColor  *currentValueShadowColor;  // normal/highlighted/selected/disabled. default is white(0,0.5).

/// The value label itself, this should **not** be used for setting the font, text value, attributed text value, text color or shadow color.
@property (nonatomic, weak, readonly) UILabel *valueLabel;

@end

///
//@interface EPVBaseContainerInputView (RDHValueDisplay)
//
//#pragma mark - Value label display
///// @name Configuring the value label display
//
///// Font for the value label, this is both the selected value and `placeholderValue`.
//@property (nonatomic, strong) UIFont *valueLabelFont;
//
///// This is for both the selected value and `placeholderValue`. If `YES`, the shadow changes from engrave to emboss appearance when highlighted. The default value is `NO`.
//@property (nonatomic, assign) BOOL reversesValueShadowWhenHighlighted;
//
///// The value label itself, this should **not** be used for setting the font, text value, attributed text value, text color or shadow color.
//@property (nonatomic, weak, readonly) UILabel *valueLabel;
//
//#pragma mark - Text and shadow colors
///// @name Text and shadow colors
//
///// The displayed value text color.
//@property (nonatomic, strong) UIColor *displayedValueTextColor;
//
///// The displayed value text shadow color.
//@property (nonatomic, strong) UIColor *displayedValueShadowColor;
//
///// The value text color when the picker is expanded.
//@property (nonatomic, strong) UIColor *expandedValueTextColor;
//
///// The value text shadow color when the picker is expanded.
//@property (nonatomic, strong) UIColor *expandedValueShadowColor;
//
//@end
//
/////
//@interface EPVBaseContainerInputView (RDHPlaceholder)
//
///// @name Display value
//
///// Placeholder text for when no value is selected.
//@property (nonatomic, copy) NSString *placeholderValue;
//
///// Attributed placeholder text for when no value is selected.
//@property (nonatomic, copy) NSAttributedString *attributedPlaceholderValue;
//
//#pragma mark - Text and shadow colors
///// @name Text and shadow colors
//
///// The placeholder value text color.
//@property (nonatomic, strong) UIColor *placeholderValueTextColor;
//
///// The placeholder value text shadow color.
//@property (nonatomic, strong) UIColor *placeholderValueShadowColor;
//
///// The placeholder highlighted value text color.
//@property (nonatomic, strong) UIColor *placeholderHighlightedValueTextColor;
//
///// The placeholder highlighted value text shadow color.
//@property (nonatomic, strong) UIColor *placeholderHighlightedValueShadowColor;
//
//@end
