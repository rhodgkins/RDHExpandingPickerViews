//
//  EPVActivationButton.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVActivationButton.h"

#import "UIImage+RDHColor.h"

#import "EPVBaseContainerInputView.h"

static void *EPVContextAttributedText = &EPVContextAttributedText;
static void *EPVContextText = &EPVContextText;

static NSString *const RDHStateKeyText = @"text";
static NSString *const RDHStateKeyColor = @"color";
static NSString *const RDHStateKeyShadowColor = @"shadowColor";
static NSString *const RDHStateKeyAttributedText = @"attributedText";

@interface EPVActivationButton ()

@property (nonatomic, copy) NSMutableDictionary *backgroundStateColors;

@property (nonatomic, copy) NSMutableDictionary *infoStates;

@end

@implementation EPVActivationButton

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

-(void)dealloc
{
    [_infoLabel removeObserver:self forKeyPath:NSStringFromSelector(@selector(text)) context:EPVContextText];
    [_infoLabel removeObserver:self forKeyPath:NSStringFromSelector(@selector(attributedText)) context:EPVContextAttributedText];
}

-(void)commonInit
{
    _activated = NO;
    
    _infoStates = [NSMutableDictionary dictionary];
    _backgroundStateColors = [NSMutableDictionary dictionary];
    
    UILabel *infoLabel = [UILabel new];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    infoLabel.numberOfLines = 1;
    [self addSubview:infoLabel];
    _infoLabel = infoLabel;
    
    // Truncate end of title text
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.numberOfLines = 1;
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    // Listen for changes to the text labels
    [self.infoLabel addObserver:self forKeyPath:NSStringFromSelector(@selector(text)) options:0 context:EPVContextText];
    [self.infoLabel addObserver:self forKeyPath:NSStringFromSelector(@selector(attributedText)) options:0 context:EPVContextAttributedText];
}

#pragma mark - Layout

-(void)layoutSubviews
{
    [super layoutSubviews];
        
    CGRect infoFrame = UIEdgeInsetsInsetRect(self.bounds, self.labelEdgeInsets);
    infoFrame.size.width = [self infoTextWidthForContainerSize:infoFrame.size];
    self.infoLabel.frame = infoFrame;
    
    UIEdgeInsets buttonTitleInsets = self.labelEdgeInsets;
    buttonTitleInsets.left = CGRectGetMaxX(self.infoLabel.frame);
    self.titleEdgeInsets = buttonTitleInsets;
}

-(CGFloat)infoTextWidthForContainerSize:(CGSize)size
{
    CGSize maxSize = size;
    maxSize.width /= 2;
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading;
    NSStringDrawingContext *context = nil;
    
    CGRect bounds;
    if (self.infoLabel.attributedText) {
        bounds = [self.infoLabel.attributedText boundingRectWithSize:maxSize options:options context:context];
    } else {
        bounds = [self.infoLabel.text boundingRectWithSize:maxSize options:options attributes:nil context:context];
    }
    
    return ceil(CGRectGetWidth(bounds));
}

-(void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_labelEdgeInsets, labelEdgeInsets)) {
        _labelEdgeInsets = labelEdgeInsets;
        
        [self setNeedsLayout];
    }
}

#pragma mark - States

-(UIControlState)state
{
    return super.state | ([self isActivated] ? RDHControlStateActivated : 0);
}

    -(void)setSelected:(BOOL)selected
    {
        super.selected = selected;
        
        [self stateUpdated];
    }

    -(void)setHighlighted:(BOOL)highlighted
    {
        super.highlighted = highlighted;
        
        [self stateUpdated];
    }

    -(void)setEnabled:(BOOL)enabled
    {
        super.enabled = enabled;
        
        [self stateUpdated];
    }

    -(void)setActivated:(BOOL)activated
    {
        _activated = activated;
        
        [self stateUpdated];
    }

    -(void)stateUpdated
    {
        [self updateInfoLabel];
    }

#pragma mark - Info label

-(void)updateInfoLabel
{
    self.infoLabel.text = self.currentInfoText;
    self.infoLabel.textColor = self.currentInfoColor;
    self.infoLabel.shadowColor = self.currentInfoShadowColor;
    if (self.currentInfoAttributedText) {
        self.infoLabel.attributedText = self.currentInfoAttributedText;
    }
}

#pragma mark - Info state

-(NSMutableDictionary *)infoForState:(UIControlState)state
{
    NSNumber *key = @(state);
    
    NSMutableDictionary *info = self.infoStates[key];
    
    if (!info) {
        info = [NSMutableDictionary dictionaryWithCapacity:4];
        self.infoStates[key] = info;
    }
    
    return info;
}

-(id)infoWithKey:(NSString *)key forState:(UIControlState)state
{
    return [self infoForState:state][key];
}

-(void)setInfoValue:(id)value withKey:(NSString *)key forState:(UIControlState)state
{
    NSMutableDictionary *info = [self infoForState:state];
    id oldValue = info[key];
    
    if (![oldValue isEqual:value]) {
        
        if (value) {
            info[key] = value;
        } else {
            [info removeObjectForKey:key];
        }
    }
}

-(void)setInfoText:(NSString *)text forState:(UIControlState)state
{
    [self setInfoValue:text withKey:RDHStateKeyText forState:state];
    
    [self updateInfoLabel];
}

-(void)setInfoColor:(UIColor *)color forState:(UIControlState)state
{
    [self setInfoValue:color withKey:RDHStateKeyColor forState:state];
    
    [self updateInfoLabel];
}

-(void)setInfoShadowColor:(UIColor *)color forState:(UIControlState)state
{
    [self setInfoValue:color withKey:RDHStateKeyShadowColor forState:state];
    
    [self updateInfoLabel];
}

-(void)setInfoAttributedText:(NSAttributedString *)text forState:(UIControlState)state
{
    [self setInfoValue:text withKey:RDHStateKeyAttributedText forState:state];
    
    [self updateInfoLabel];
}

-(NSString *)infoTextForState:(UIControlState)state
{
    NSString *text = [self infoWithKey:RDHStateKeyText forState:state];
    
    if (!text & (state != UIControlStateNormal)) {
        text = [self infoTextForState:UIControlStateNormal];
    }
    
    return text;
}

-(UIColor *)infoColorForState:(UIControlState)state
{
    UIColor *color = [self infoWithKey:RDHStateKeyColor forState:state];
    
    if (!color & (state != UIControlStateNormal)) {
        color = [self infoColorForState:UIControlStateNormal];
    }
    
    return color;
}

-(UIColor *)infoShadowColorForState:(UIControlState)state
{
    UIColor *color = [self infoWithKey:RDHStateKeyShadowColor forState:state];
    
    if (!color & (state != UIControlStateNormal)) {
        color = [self infoShadowColorForState:UIControlStateNormal];
    }
    
    return color;
}

-(NSAttributedString *)infoAttributedTextForState:(UIControlState)state
{
    NSAttributedString *text = [self infoWithKey:RDHStateKeyAttributedText forState:state];
    
    if (!text & (state != UIControlStateNormal)) {
        text = [self infoAttributedTextForState:UIControlStateNormal];
    }
    
    return text;
}

-(NSString *)currentInfoText
{
    return [self infoTextForState:self.state];
}

-(UIColor *)currentInfoColor
{
    return [self infoColorForState:self.state];
}

-(UIColor *)currentInfoShadowColor
{
    return [self infoShadowColorForState:self.state];
}

-(NSAttributedString *)currentInfoAttributedText
{
    return [self infoAttributedTextForState:self.state];
}

#pragma mark - Background state

-(void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    NSNumber *key = @(state);
    UIColor *oldColor = self.backgroundStateColors[key];
    
    if (![oldColor isEqual:color]) {
        
        UIImage *colorImage = nil;
        
        if (color) {
            // Update
            self.backgroundStateColors[key] = color;
            
            colorImage = [UIImage imageWithColor:color];
            
        } else {
            // Clear
            [self.backgroundStateColors removeObjectForKey:key];
        }
        
        [self setBackgroundImage:colorImage forState:state];
    }
}

-(UIColor *)backgroundColorForState:(UIControlState)state
{
    return self.backgroundStateColors[@(state)];
}

-(UIColor *)currentBackgroundColor
{
    return [self backgroundColorForState:self.state];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == EPVContextText || context == EPVContextAttributedText) {
        [self setNeedsLayout];
    } else if ([super respondsToSelector:_cmd]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
