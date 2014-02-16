//
//  EPVBaseContainerInputView.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVBaseContainerInputView.h"
#import "EPVBaseContainerInputView_EPVInternal.h"

#import "UIImage+RDHColor.h"

#import "EPVActivationButton.h"

const EPVPickerViewHeight EPVPickerViewHeightShortest = 162.0;
const EPVPickerViewHeight EPVPickerViewHeightStandard = 180.0;
const EPVPickerViewHeight EPVPickerViewHeightHighest = 216.0;

@interface EPVBaseContainerInputView ()

/// Button that activates the view.
@property (nonatomic, weak, readonly) EPVActivationButton *button;

@property (nonatomic, weak, readonly) NSLayoutConstraint *heightConstraint;

@end

@implementation EPVBaseContainerInputView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    DEBUG_COLOR(self, yellowColor);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = NO;
    
    _displayHeight = 34;
    _pickerViewHeight = EPVPickerViewHeightStandard;
    
    self.labelEdgeInsets = UIEdgeInsetsZero;
    
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    EPVActivationButton *button = [EPVActivationButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [button addTarget:self action:@selector(didTapActivationButton) forControlEvents:UIControlEventTouchUpInside];
    DEBUG_COLOR(button, greenColor);
    [self addSubview:button];
    _button = button;
    
    UIView *pickerView = [self createPickerView];
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pickerView.alpha = 0;
    DEBUG_COLOR(pickerView, purpleColor);
    [self addSubview:pickerView];
    _pickerView = pickerView;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    heightConstraint.priority = UILayoutPriorityRequired;
    [self addConstraint:heightConstraint];
    _heightConstraint = heightConstraint;
    
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.titleLabel.highlightedTextColor = [UIColor lightTextColor];
    [self setDisplayedValueTextColor:[UIColor darkTextColor]];
    [self setPlaceholderValueTextColor:[UIColor lightGrayColor]];
    
    [self togglePicker:NO];
    
    self.selectedObject = nil;
}

-(CGSize)intrinsicContentSize
{
    // Use the intrinsic size of the widest view
    CGFloat widestView = MAX([self.button intrinsicContentSize].width, [self.pickerView intrinsicContentSize].width);
    return CGSizeMake(widestView, [self contentHeight]);
}

-(CGFloat)contentHeight
{
    CGFloat height = self.displayHeight;
    if ([self isFirstResponder]) {
        height += self.pickerViewHeight;
    }
    return height;
}

-(void)setDisplayHeight:(CGFloat)displayHeight
{
    if (_displayHeight != displayHeight) {
        _displayHeight = displayHeight;
        
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}

-(void)setDisplayBackgroundColor:(UIColor *)displayBackgroundColor
{
    if (![_displayBackgroundColor isEqual:displayBackgroundColor]) {
        _displayBackgroundColor = displayBackgroundColor;
        
        UIImage *image = nil;
        if (_displayBackgroundColor) {
            image = [UIImage imageWithColor:_displayBackgroundColor];
        }
        [self.button setBackgroundImage:image forState:UIControlStateNormal];
        [self.button setBackgroundImage:image forState:UIControlStateNormal | UIControlStateSelected];
    }
}

-(void)setDisplayHighlightedBackgroundColor:(UIColor *)displayHighlightedBackgroundColor
{
    if (![_displayHighlightedBackgroundColor isEqual:displayHighlightedBackgroundColor]) {
        _displayHighlightedBackgroundColor = displayHighlightedBackgroundColor;
        
        UIImage *image = nil;
        if (_displayHighlightedBackgroundColor) {
            image = [UIImage imageWithColor:_displayHighlightedBackgroundColor];
        }
        [self.button setBackgroundImage:image forState:UIControlStateHighlighted];
        [self.button setBackgroundImage:image forState:UIControlStateHighlighted | UIControlStateSelected];
    }
}

-(void)setPickerViewHeight:(EPVPickerViewHeight)pickerViewHeight
{
    if (_pickerViewHeight != pickerViewHeight) {
        _pickerViewHeight = pickerViewHeight;
        
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}

-(UIColor *)pickerViewBackgroundColor
{
    return self.pickerView.backgroundColor;
}

-(void)setPickerViewBackgroundColor:(UIColor *)pickerViewBackgroundColor
{
    self.pickerView.backgroundColor = pickerViewBackgroundColor;
}

-(UIEdgeInsets)labelEdgeInsets
{
    return self.button.labelEdgeInsets;
}

-(void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets
{
    self.button.labelEdgeInsets = labelEdgeInsets;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect buttonFrame = self.bounds;
    buttonFrame.size.height = self.displayHeight;
    self.button.frame = buttonFrame;
    
    CGRect pickerFrame = self.bounds;
    pickerFrame.origin.y = CGRectGetMaxY(buttonFrame);
    pickerFrame.size.height = self.pickerViewHeight;
    pickerFrame.size.width = CGRectGetWidth(self.bounds);
    self.pickerView.frame = pickerFrame;
}

#pragma mark - Picker animation

-(void)togglePicker:(BOOL)animated
{
    self.button.activated = [self isFirstResponder];
    self.heightConstraint.constant = [self contentHeight];
    dispatch_block_t animationBlock = ^{
        self.pickerView.alpha = [self isFirstResponder] ? 1 : 0;
        [self.superview layoutIfNeeded];
    };
    void(^completionBlock)(BOOL) = ^(BOOL finished) {
        [self invalidateIntrinsicContentSize];
    };
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:animationBlock completion:completionBlock];
    } else {
        animationBlock();
        completionBlock(YES);
    }
}

#pragma mark - Object selection

-(void)setSelectedObject:(id)selectedObject
{
    [self setSelectedObject:selectedObject animated:NO];
}

-(void)setSelectedObject:(id)selectedObject animated:(BOOL)animated
{
    _selectedObject = [selectedObject copy];
    
    // We're selected if we've got a selected object
    self.button.selected = _selectedObject != nil;
    
    [self updateValueDisplay];
}

#pragma mark - Targets

-(void)didTapActivationButton
{
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    } else {
        [self becomeFirstResponder];
    }
}

#pragma mark - Value label display

-(UIFont *)valueLabelFont
{
    return self.button.titleLabel.font;
}

-(void)setValueLabelFont:(UIFont *)valueLabelFont
{
    self.button.titleLabel.font = valueLabelFont;
}

-(BOOL)reversesValueShadowWhenHighlighted
{
    return [self.button reversesTitleShadowWhenHighlighted];
}

-(void)setReversesValueShadowWhenHighlighted:(BOOL)reversesValueShadowWhenHighlighted
{
    self.button.reversesTitleShadowWhenHighlighted = reversesValueShadowWhenHighlighted;
}

-(UIColor *)displayedValueTextColor
{
    return [self.button titleColorForState:UIControlStateSelected];
}

-(void)setDisplayedValueTextColor:(UIColor *)displayedValueTextColor
{
    [self.button setTitleColor:displayedValueTextColor forState:UIControlStateSelected];
    [self.button setTitleColor:displayedValueTextColor forState:UIControlStateSelected | UIControlStateHighlighted];
}

-(UIColor *)displayedValueShadowColor
{
    return [self.button titleShadowColorForState:UIControlStateSelected];
}

-(void)setDisplayedValueShadowColor:(UIColor *)displayedValueShadowColor
{
    [self.button setTitleShadowColor:displayedValueShadowColor forState:UIControlStateSelected];
    [self.button setTitleShadowColor:displayedValueShadowColor forState:UIControlStateSelected | UIControlStateHighlighted];
}

-(UIColor *)expandedValueTextColor
{
    return [self.button titleColorForState:UIControlStateActivated];
}

-(void)setExpandedValueTextColor:(UIColor *)expandedValueTextColor
{
    [self.button setTitleColor:expandedValueTextColor forState:UIControlStateActivated];
    [self.button setTitleColor:expandedValueTextColor forState:UIControlStateActivated| UIControlStateSelected];
    [self.button setTitleColor:expandedValueTextColor forState:UIControlStateActivated |UIControlStateSelected | UIControlStateHighlighted];
}

-(UIColor *)expandedValueShadowColor
{
    return [self.button titleShadowColorForState:UIControlStateActivated];
}

-(void)setExpandedValueShadowColor:(UIColor *)expandedValueShadowColor
{
    [self.button setTitleShadowColor:expandedValueShadowColor forState:UIControlStateSelected];
    [self.button setTitleShadowColor:expandedValueShadowColor forState:UIControlStateSelected | UIControlStateHighlighted];
}

-(NSString *)placeholderValue
{
    return [self.button titleForState:UIControlStateNormal];
}

-(void)setPlaceholderValue:(NSString *)placeholderValue
{
    [self.button setTitle:placeholderValue forState:UIControlStateNormal];
    [self.button setTitle:placeholderValue forState:UIControlStateNormal | UIControlStateHighlighted];
}

-(NSAttributedString *)attributedPlaceholderValue
{
    return [self.button attributedTitleForState:UIControlStateNormal];
}

-(void)setAttributedPlaceholderValue:(NSAttributedString *)attributedPlaceholderValue
{
    [self.button setAttributedTitle:attributedPlaceholderValue forState:UIControlStateNormal];
    [self.button setAttributedTitle:attributedPlaceholderValue forState:UIControlStateNormal | UIControlStateHighlighted];
}

-(UIColor *)placeholderValueTextColor
{
    return [self.button titleColorForState:UIControlStateNormal];
}

-(void)setPlaceholderValueTextColor:(UIColor *)placeholderValueTextColor
{
    [self.button setTitleColor:placeholderValueTextColor forState:UIControlStateNormal];
    [self.button setTitleColor:placeholderValueTextColor forState:UIControlStateNormal | UIControlStateHighlighted];
}

-(UIColor *)placeholderValueShadowColor
{
    return [self.button titleShadowColorForState:UIControlStateNormal];
}

-(void)setPlaceholderValueShadowColor:(UIColor *)placeholderValueShadowColor
{
    [self.button setTitleShadowColor:placeholderValueShadowColor forState:UIControlStateNormal];
    [self.button setTitleShadowColor:placeholderValueShadowColor forState:UIControlStateNormal | UIControlStateHighlighted];
}

-(UILabel *)valueLabel
{
    return self.button.titleLabel;
}

#pragma mark - Title label

-(UILabel *)titleLabel
{
    return self.button.infoLabel;
}

#pragma mark - Value updating

-(void)updateValueDisplay
{
    if (self.selectedObject) {
        NSAttributedString *attributedTitle = [self attributedDisplayValueForSelectedObject];
        if (attributedTitle) {
            [self.button setAttributedTitle:attributedTitle forState:UIControlStateActivated | UIControlStateSelected];
            [self.button setAttributedTitle:attributedTitle forState:UIControlStateSelected];
            [self.button setAttributedTitle:attributedTitle forState:UIControlStateSelected | UIControlStateHighlighted];
        } else {
            NSString *title = [self displayValueForSelectedObject];
            [self.button setTitle:title forState:UIControlStateActivated | UIControlStateSelected];
            [self.button setTitle:title forState:UIControlStateSelected];
            [self.button setTitle:title forState:UIControlStateSelected | UIControlStateHighlighted];
        }
    } else {
        [self.button setTitle:nil forState:UIControlStateSelected];
        [self.button setTitle:nil forState:UIControlStateSelected | UIControlStateHighlighted];
        [self.button setAttributedTitle:nil forState:UIControlStateSelected];
        [self.button setAttributedTitle:nil forState:UIControlStateSelected | UIControlStateHighlighted];
    }
}

#pragma mark - Responder chain

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (result) {
        [self togglePicker:YES];
        // When we're allowed to become first responder set the initial object
        if (!self.selectedObject) {
            self.selectedObject = self.initiallySelectedObject;
        }
    }
    return result;
}

-(BOOL)canResignFirstResponder
{
    return YES;
}

-(BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if (result) {
        [self togglePicker:YES];
    }
    return result;
}

#pragma mark - Required subclass methods

-(UIView *)createPickerView
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass returning a view", NSStringFromSelector(_cmd)] userInfo:nil];
}

-(NSString *)displayValueForSelectedObject
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass returning a string", NSStringFromSelector(_cmd)] userInfo:nil];
}

#pragma mark - Optional subclass methods

-(NSAttributedString *)attributedDisplayValueForSelectedObject
{
    return nil;
}

@end
