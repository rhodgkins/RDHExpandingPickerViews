//
//  EPVActivationButton.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPVActivationButton : UIButton

/// Activated == expanded
@property (nonatomic, assign, getter = isActivated) BOOL activated;

@property (nonatomic, assign) UIEdgeInsets labelEdgeInsets;

/// Displays the title
@property (nonatomic, weak, readonly) UILabel *infoLabel;

#pragma mark - Info state
/// @name Info state

-(void)setInfoText:(NSString *)text forState:(UIControlState)state;

-(void)setInfoColor:(UIColor *)color forState:(UIControlState)state;

-(void)setInfoShadowColor:(UIColor *)color forState:(UIControlState)state;

-(void)setInfoAttributedText:(NSAttributedString *)text forState:(UIControlState)state;

-(NSString *)infoTextForState:(UIControlState)state;

-(UIColor *)infoColorForState:(UIControlState)state;

-(UIColor *)infoShadowColorForState:(UIControlState)state;

-(NSAttributedString *)infoAttributedTextForState:(UIControlState)state;

@property (nonatomic, readonly, strong) NSString *currentInfoText;
@property (nonatomic, readonly, strong) UIColor *currentInfoColor;
@property (nonatomic, readonly, strong) UIColor *currentInfoShadowColor;
@property (nonatomic, readonly, strong) NSAttributedString *currentInfoAttributedText;

#pragma mark - Background state
/// @name Background state

-(void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR;                     // default is transparent black.

-(UIColor *)backgroundColorForState:(UIControlState)state;          // these getters only take a single state value

@property (nonatomic, readonly, strong) UIColor *currentBackgroundColor;  // normal/highlighted/selected/disabled. can return nil

@end
