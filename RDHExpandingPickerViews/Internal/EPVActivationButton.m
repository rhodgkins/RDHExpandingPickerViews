//
//  EPVActivationButton.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "EPVActivationButton.h"

#import "EPVBaseContainerInputView_EPVInternal.h"

const UIControlState UIControlStateActivated = UIControlStateApplication;

static void *EPVContextAttributedText = &EPVContextAttributedText;
static void *EPVContextText = &EPVContextText;

@interface EPVActivationButton ()

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
    
    UILabel *infoLabel = [UILabel new];
    infoLabel.backgroundColor = [UIColor clearColor];
    DEBUG_COLOR(infoLabel, redColor);
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    infoLabel.numberOfLines = 1;
    [self addSubview:infoLabel];
    _infoLabel = infoLabel;
    
    // Truncate end of title text
    DEBUG_COLOR(self.titleLabel, brownColor);
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.numberOfLines = 1;
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    // Listen for changes to the text labels
    [self.infoLabel addObserver:self forKeyPath:NSStringFromSelector(@selector(text)) options:0 context:EPVContextText];
    [self.infoLabel addObserver:self forKeyPath:NSStringFromSelector(@selector(attributedText)) options:0 context:EPVContextAttributedText];
}

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

-(void)setHighlighted:(BOOL)highlighted
{
    super.highlighted = highlighted;
    self.infoLabel.highlighted = highlighted;
}

-(void)setEnabled:(BOOL)enabled
{
    super.enabled = enabled;
    self.infoLabel.enabled = enabled;
}

-(void)setActivated:(BOOL)activated
{
    _activated = activated;
    // Toggle change of state
    BOOL enabled = super.enabled;
    super.enabled = !enabled;
    super.enabled = enabled;
    [self layoutIfNeeded];
}

-(UIControlState)state
{
    return super.state | ([self isActivated] ? UIControlStateActivated : 0);
}

-(void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_labelEdgeInsets, labelEdgeInsets)) {
        _labelEdgeInsets = labelEdgeInsets;
 
        [self setNeedsLayout];
    }
}

-(CGFloat)infoTextWidthForContainerSize:(CGSize)size
{
    CGSize maxSize = size;
    maxSize.width /= 2;
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading;
    
    CGRect bounds;
    if (self.infoLabel.attributedText) {
        bounds = [self.infoLabel.attributedText boundingRectWithSize:maxSize options:options context:nil];
    } else {
        bounds = [self.infoLabel.text boundingRectWithSize:maxSize options:options attributes:nil context:nil];
    }
    
    return ceil(CGRectGetWidth(bounds));
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == EPVContextText || context == EPVContextAttributedText) {
        [self setNeedsLayout];
    } else if ([super respondsToSelector:_cmd]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
