//
//  EPVBaseContainerInputView.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat EPVPickerViewHeight;

/// 162 pts
UIKIT_EXTERN const EPVPickerViewHeight EPVPickerViewHeightShortest;
/// 180 pts
UIKIT_EXTERN const EPVPickerViewHeight EPVPickerViewHeightStandard;
/// 216 pts
UIKIT_EXTERN const EPVPickerViewHeight EPVPickerViewHeightHighest;

@interface EPVBaseContainerInputView : UIControl

@property (nonatomic, assign) CGFloat displayHeight;

@property (nonatomic, strong) UIColor *displayBackgroundColor;

@property (nonatomic, strong) UIColor *displayHighlightedBackgroundColor;

@property (nonatomic, assign) EPVPickerViewHeight pickerViewHeight;

@property (nonatomic, strong) UIColor *pickerViewBackgroundColor;

/// Insets for the labels (both the `titleLabel` and `valueLabel`). The left value will be used for the `titleLabel` and the right for the `valueLabel`. Default value is `UIEdgeInsetsZero`.
@property (nonatomic, assign) UIEdgeInsets labelEdgeInsets;

#pragma mark - Title label display
/// @name Configuring the title label display

/// The label that shows what can be selected.
@property (nonatomic, weak, readonly) UILabel *titleLabel;

#pragma mark - Value label display
/// @name Configuring the value label display

/// Font for the value label, this is both the selected value and `placeholderValue`.
@property (nonatomic, strong) UIFont *valueLabelFont;

/// This is for both the selected value and `placeholderValue`. If `YES`, the shadow changes from engrave to emboss appearance when highlighted. The default value is `NO`.
@property (nonatomic, assign) BOOL reversesValueShadowWhenHighlighted;

/// The displayed value text color.
@property (nonatomic, strong) UIColor *displayedValueTextColor;

/// The displayed value text shadow color.
@property (nonatomic, strong) UIColor *displayedValueShadowColor;

/// The value text color when the picker is expanded.
@property (nonatomic, strong) UIColor *expandedValueTextColor;

/// The value text shadow color when the picker is expanded.
@property (nonatomic, strong) UIColor *expandedValueShadowColor;

/// Placeholder text for when no value is selected.
@property (nonatomic, copy) NSString *placeholderValue;

/// Attributed placeholder text for when no value is selected.
@property (nonatomic, copy) NSAttributedString *attributedPlaceholderValue;

/// The placeholder value text color.
@property (nonatomic, strong) UIColor *placeholderValueTextColor;

/// The placeholder value text shadow color.
@property (nonatomic, strong) UIColor *placeholderValueShadowColor;

/// The value label itself, this should **not** be used for setting the font, text value, attributed text value, text color or shadow color.
@property (nonatomic, weak, readonly) UILabel *valueLabel;

@end
