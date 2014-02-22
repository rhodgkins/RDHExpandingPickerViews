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

/// RGB - 8 bit [0, 255], A - float, [0,1]
#define UIColorWithRGBA(R, G, B, A) ([UIColor colorWithRed:((R)/255.0) green:((G)/255.0) blue:((B)/255.0) alpha:(A)])
/// RGB - 8 bit [0, 255]
#define UIColorWithRGB(R, G, B) (UIColorWithRGBA((R), (G), (B), 1.0))
/// Gray - 8 bit [0, 255], A - float, [0,1]
#define UIColorWithGrayAlpha(GRAY, A) ([UIColor colorWithWhite:((GRAY)/255.0) alpha:(A)])
/// Gray - 8 bit [0, 255]
#define UIColorWithGray(GRAY) (UIColorWithGrayAlpha((GRAY), 1.0))

const CGFloat RDHStandardDisabledAlpha = 0.26667;

const UIControlState RDHControlStateActivated = UIControlStateApplication;

const EPVPickerViewHeight EPVPickerViewHeightShortest = 162.0;
const EPVPickerViewHeight EPVPickerViewHeightStandard = 180.0;
const EPVPickerViewHeight EPVPickerViewHeightHighest = 216.0;

@interface EPVBaseContainerInputView ()
{
@private
    BOOL subclassInstantiation;
}

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
        subclassInstantiation = NO;
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        subclassInstantiation = NO;
        [self commonInit];
    }
    return self;
}

-(void)subclassCalled
{
    subclassInstantiation = YES;
}

-(void)commonInit
{
    if (!subclassInstantiation) {
        [NSException raise:NSInternalInconsistencyException format:@"%@ cannot be used directly, a subclass must be used.", NSStringFromClass([self class])];
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    [self addTarget:self action:@selector(didTapActivationButton) forControlEvents:UIControlEventTouchUpInside];
    
    _displayHeight = 34;
    _pickerViewHeight = EPVPickerViewHeightStandard;
    
    self.labelEdgeInsets = UIEdgeInsetsZero;
    
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    EPVActivationButton *button = [EPVActivationButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:button];
    _button = button;
    
    UIView *pickerView = [self createPickerView];
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pickerView.alpha = 0;
    pickerView.tintColor = [UIColor redColor];
    [self addSubview:pickerView];
    _pickerView = pickerView;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    heightConstraint.priority = UILayoutPriorityRequired;
    [self addConstraint:heightConstraint];
    _heightConstraint = heightConstraint;
    
    self.pickerViewBackgroundColor = [UIColor clearColor];
    
    [self togglePicker:NO];
    self.activated = NO;
    
    self.selectedObject = nil;
    
    [self setupDefaultStates];
}

-(void)setupDefaultStates
{
    // For all states
    [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self setValueColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    
    // Selected states
    [self setValueColor:[UIColor darkTextColor] forState:UIControlStateSelected];
    [self setValueColor:[UIColor darkTextColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self setValueColor:[UIColor darkTextColor] forState:UIControlStateSelected | RDHControlStateActivated];
    [self setValueColor:[UIColor darkTextColor] forState:UIControlStateSelected | UIControlStateHighlighted | RDHControlStateActivated];
    
    // Disabled state
    [self setTitleColor:[[self class] disabledTextColor] forState:UIControlStateDisabled];
    [self setValueColor:[[self class] disabledTextColor] forState:UIControlStateDisabled];
    [self setTitleColor:[[self class] disabledTextColor] forState:UIControlStateDisabled | UIControlStateSelected];
    [self setValueColor:[[self class] disabledTextColor] forState:UIControlStateDisabled | UIControlStateSelected];
    
    // Placeholder text color
    self.placeholderValueColor = [[self class] placeholderValueColor];
    
    // Highlighted states
    [self setLabelBackgroundColor:[[self class] highlightedLabelBackgroundColor] forState:UIControlStateHighlighted];
    [self setLabelBackgroundColor:[[self class] highlightedLabelBackgroundColor] forState:UIControlStateHighlighted | RDHControlStateActivated];
    [self setLabelBackgroundColor:[[self class] highlightedLabelBackgroundColor] forState:UIControlStateHighlighted | RDHControlStateActivated | UIControlStateSelected];
    [self setLabelBackgroundColor:[[self class] highlightedLabelBackgroundColor] forState:UIControlStateHighlighted | UIControlStateSelected];
    
    // Activated states
    [self setValueColor:[[self class] activatedValueColor] forState:RDHControlStateActivated];
    [self setValueColor:[[self class] activatedValueColor] forState:RDHControlStateActivated | UIControlStateNormal];
    [self setValueColor:[[self class] activatedValueColor] forState:RDHControlStateActivated | UIControlStateNormal | UIControlStateHighlighted];
    [self setValueColor:[[self class] activatedValueColor] forState:RDHControlStateActivated | UIControlStateSelected];
    [self setValueColor:[[self class] activatedValueColor] forState:RDHControlStateActivated | UIControlStateSelected | UIControlStateHighlighted];
}

#pragma mark - Layout

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

-(CGSize)intrinsicContentSize
{
    // Use the intrinsic size of the widest view
    CGFloat widestView = MAX([self.button intrinsicContentSize].width, [self.pickerView intrinsicContentSize].width);
    return CGSizeMake(widestView, [self contentHeight]);
}

-(CGFloat)contentHeight
{
    CGFloat height = self.displayHeight;
    if ([self isActivated]) {
        height += self.pickerViewHeight;
    }
    return height;
}

-(void)setDisplayHeight:(CGFloat)displayHeight
{
    if (_displayHeight != displayHeight) {
        _displayHeight = displayHeight;
        
        [self invalidateIntrinsicContentSize];
        self.heightConstraint.constant = [self contentHeight];
        [self setNeedsLayout];
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

-(UIEdgeInsets)labelEdgeInsets
{
    return self.button.labelEdgeInsets;
}

-(void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets
{
    self.button.labelEdgeInsets = labelEdgeInsets;
}

#pragma mark - State control

-(UIControlState)state
{
    return super.state | ([self isActivated] ? RDHControlStateActivated : 0);
}

-(void)setHighlighted:(BOOL)highlighted
{
    super.highlighted = highlighted;
    
    [self stateUpdated];
}

-(void)setSelected:(BOOL)selected
{
    NSLog(@"This method does nothing as the selected state is based on the selected object: %@", NSStringFromSelector(_cmd));
}

-(void)setEnabled:(BOOL)enabled
{
    super.enabled = enabled;
    
    if (!self.enabled) {
        [self setActivated:NO animated:YES];
    }
    
    [self stateUpdated];
}

-(BOOL)isActivated
{
    return self.button.activated;
}

-(void)setActivated:(BOOL)activated
{
    [self setActivated:activated animated:NO];
}

-(void)setActivated:(BOOL)activated animated:(BOOL)animated
{
    BOOL changed = self.activated != activated;
    self.button.activated = activated;
    if (changed) {
        [self stateUpdated];
        [self togglePicker:animated];
    }
}

-(void)stateUpdated
{
    // Pass thru to button
    self.button.highlighted = self.highlighted;
    self.button.selected = self.selected;
    self.button.enabled = self.enabled;
    self.button.activated = self.activated;
        
    [self updateValueDisplay];
}

#pragma mark - Value updating

-(void)updateValueDisplay
{
    if (self.selectedObject) {
        NSAttributedString *attributedTitle = [self attributedDisplayValueForSelectedObject];
        if (attributedTitle) {
            [self setSelectedAttributedValue:attributedTitle];
        } else {
            NSString *title = [self displayValueForSelectedObject];
            [self setSelectedValue:title];
        }
    } else {
        [self setSelectedValue:nil];
        [self setSelectedAttributedValue:nil];
    }
    // Layout the button
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    [self.button layoutIfNeeded];
    [CATransaction commit];
}

+(NSArray *)selectedStates
{
    static NSArray *states;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *enabledStates = @[@(RDHControlStateActivated | UIControlStateSelected),
                   @(UIControlStateSelected),
                   @(UIControlStateSelected | UIControlStateHighlighted),
                   @(RDHControlStateActivated | UIControlStateSelected | UIControlStateHighlighted)];
        
        // Copy and add disabled states
        NSMutableArray *allStates = [enabledStates mutableCopy];
        [allStates addObject:@(UIControlStateDisabled)];
        for (NSNumber *enabledState in enabledStates) {
            [allStates addObject:@([enabledState unsignedIntegerValue] | UIControlStateDisabled)];
        }
        states = [allStates copy];
    });
    return states;
}

-(void)setSelectedValue:(NSString *)text
{
    for (NSNumber *state in [[self class] selectedStates]) {
        [self.button setTitle:text forState:[state unsignedIntegerValue]];
    }
}

-(void)setSelectedAttributedValue:(NSAttributedString *)text
{
    for (NSNumber *state in [[self class] selectedStates]) {
        [self.button setAttributedTitle:text forState:[state unsignedIntegerValue]];
    }
}

#pragma mark - Picker animation

-(void)togglePicker:(BOOL)animated
{
    self.heightConstraint.constant = [self contentHeight];
    dispatch_block_t animationBlock = ^{
        self.pickerView.alpha = [self isActivated] ? 1 : 0;
        [self.superview layoutIfNeeded];
    };
    void(^completionBlock)(BOOL) = ^(BOOL finished) {
        [self invalidateIntrinsicContentSize];
    };
    if (animated) {
        [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:animationBlock completion:completionBlock];
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
    
    // Call super because calling self.selected does nothing
    super.selected = _selectedObject != nil;
    
    [self stateUpdated];
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

#pragma mark - Hit tests

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint buttonPoint = [self.button convertPoint:point fromView:self];
    if ([self.button pointInside:buttonPoint withEvent:event]) {
        return self;
    } else {
        return [super hitTest:point withEvent:event];
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
        [self setActivated:YES animated:YES];
        [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
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
        [self setActivated:NO animated:YES];
        [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
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

-(id)initiallySelectedObject
{
    return nil;
}

#pragma mark - Colors

+(UIColor *)activatedValueColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorWithRGB(252, 61, 57);
    });
    return color;
}

+(UIColor *)highlightedLabelBackgroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorWithGray(217);
    });
    return color;
}

+(UIColor *)placeholderValueColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorWithGray(142);
    });
    return color;
}

+(UIColor *)disabledTextColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorWithGrayAlpha(0, RDHStandardDisabledAlpha);
    });
    return color;
}

@end

@implementation EPVBaseContainerInputView (RDHStateDisplay)

#pragma mark - Label background color

-(void)setLabelBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    [self.button setBackgroundColor:color forState:state];
}

-(UIColor *)labelBackgroundColorForState:(UIControlState)state
{
    return [self.button backgroundColorForState:state];
}

-(UIColor *)currentLabelBackgroundColor
{
    return [self labelBackgroundColorForState:self.state];
}

#pragma mark - Title display

-(UIFont *)titleFont
{
    return self.titleLabel.font;
}

-(void)setTitleFont:(UIFont *)titleFont
{
    self.titleLabel.font = titleFont;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [self.button setInfoText:title forState:state];
}

-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [self.button setInfoColor:color forState:state];
}

-(void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state
{
    [self.button setInfoShadowColor:color forState:state];
}

-(void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state
{
    [self.button setInfoAttributedText:title forState:state];
}

-(NSString *)titleForState:(UIControlState)state
{
    return [self.button infoTextForState:state];
}

-(UIColor *)titleColorForState:(UIControlState)state
{
    return [self.button infoColorForState:state];
}

-(UIColor *)titleShadowColorForState:(UIControlState)state
{
    return [self.button infoShadowColorForState:state];
}

-(NSAttributedString *)attributedTitleForState:(UIControlState)state
{
    return [self.button infoAttributedTextForState:state];
}

-(NSString *)currentTitle
{
    return [self titleForState:self.state];
}

-(UIColor *)currentTitleColor
{
    return [self titleColorForState:self.state];
}

-(UIColor *)currentTitleShadowColor
{
    return [self titleShadowColorForState:self.state];
}

-(NSAttributedString *)currentAttributedTitle
{
    return [self attributedTitleForState:self.state];
}

-(UILabel *)titleLabel
{
    return self.button.infoLabel;
}

#pragma mark - Value display

+(NSArray *)placeholderStates
{
    static NSArray *states;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        states = @[@(UIControlStateNormal),
                   @(UIControlStateNormal | RDHControlStateActivated),
                   @(UIControlStateNormal | UIControlStateHighlighted),
                   @(UIControlStateNormal | UIControlStateHighlighted | RDHControlStateActivated)];
    });
    return states;
}

+(NSArray *)placeholderDisabledStates
{
    static NSArray *states;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        states = @[@(UIControlStateNormal | UIControlStateDisabled),
                   @(UIControlStateNormal | RDHControlStateActivated | UIControlStateDisabled),
                   @(UIControlStateNormal | UIControlStateHighlighted | UIControlStateDisabled),
                   @(UIControlStateNormal | UIControlStateHighlighted | RDHControlStateActivated | UIControlStateDisabled)];
    });
    return states;
}

-(NSString *)placeholderValue
{
    return [self.button titleForState:[[[[self class] placeholderStates] firstObject] unsignedIntegerValue]];
}

-(void)setPlaceholderValue:(NSString *)text
{
    for (NSNumber *state in [[self class] placeholderStates]) {
        [self.button setTitle:text forState:[state unsignedIntegerValue]];
    }
    for (NSNumber *state in [[self class] placeholderDisabledStates]) {
        [self.button setTitle:text forState:[state unsignedIntegerValue]];
    }
}

-(NSAttributedString *)attributedPlaceholderValue
{
    return [self.button attributedTitleForState:[[[[self class] placeholderStates] firstObject] unsignedIntegerValue]];
}

-(void)setAttributedPlaceholderValue:(NSAttributedString *)text
{
    for (NSNumber *state in [[self class] placeholderStates]) {
        [self.button setAttributedTitle:text forState:[state unsignedIntegerValue]];
    }
    for (NSNumber *state in [[self class] placeholderDisabledStates]) {
        [self.button setAttributedTitle:text forState:[state unsignedIntegerValue]];
    }
}

-(UIColor *)placeholderValueColor
{
    return [self valueColorForState:[[[[self class] placeholderStates] firstObject] unsignedIntegerValue]];
}

-(void)setPlaceholderValueColor:(UIColor *)color
{
    for (NSNumber *state in [[self class] placeholderStates]) {
        [self setValueColor:color forState:[state unsignedIntegerValue]];
    }
    UIColor *disabledColor = [color colorWithAlphaComponent:RDHStandardDisabledAlpha];
    for (NSNumber *state in [[self class] placeholderDisabledStates]) {
        [self setValueColor:disabledColor forState:[state unsignedIntegerValue]];
    }
}

-(UIFont *)valueFont
{
    return self.valueLabel.font;
}

-(void)setValueFont:(UIFont *)valueFont
{
    self.valueLabel.font = valueFont;
}

-(void)setValueColor:(UIColor *)color forState:(UIControlState)state
{
    [self.button setTitleColor:color forState:state];
}

-(void)setValueShadowColor:(UIColor *)color forState:(UIControlState)state
{
    [self.button setTitleShadowColor:color forState:state];
}

-(UIColor *)valueColorForState:(UIControlState)state
{
    return [self.button titleColorForState:state];
}

-(UIColor *)valueShadowColorForState:(UIControlState)state
{
    return [self.button titleShadowColorForState:state];
}

-(UIColor *)currentValueColor
{
    return [self valueColorForState:self.state];
}

-(UIColor *)currentValueShadowColor
{
    return [self valueShadowColorForState:self.state];
}

-(UILabel *)valueLabel
{
    return self.button.titleLabel;
}

@end

@implementation EPVBaseContainerInputView (RDHPickerDisplay)


-(UIColor *)pickerViewBackgroundColor
{
    return self.pickerView.backgroundColor;
}

-(void)setPickerViewBackgroundColor:(UIColor *)pickerViewBackgroundColor
{
    self.pickerView.backgroundColor = pickerViewBackgroundColor;
}

@end