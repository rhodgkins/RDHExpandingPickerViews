//
//  RDHActivationButton.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RDHActivationButton : UIButton

/// Activated == expanded
@property (nonatomic, assign, getter = isActivated) BOOL activated;

@property (nonatomic, assign) UIEdgeInsets labelEdgeInsets;

/// Displays the title
@property (nonatomic, assign, readonly) UILabel *infoLabel;


@end

@interface RDHActivationButton (RDHBackgroundStates)

#pragma mark - Background state
/// @name Background state

-(void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR;                     // default is transparent black.

-(nullable UIColor *)backgroundColorForState:(UIControlState)state;          // these getters only take a single state value

@property (nonatomic, readonly, strong, nullable) UIColor *currentBackgroundColor;  // normal/highlighted/selected/disabled. can return nil

@end

@interface RDHActivationButton (RDHInfoStates)

#pragma mark - Info state
/// @name Info state

-(void)setInfoText:(nullable NSString *)text forState:(UIControlState)state;

-(void)setInfoColor:(nullable UIColor *)color forState:(UIControlState)state;

-(void)setInfoShadowColor:(nullable UIColor *)color forState:(UIControlState)state;

-(void)setInfoAttributedText:(nullable NSAttributedString *)text forState:(UIControlState)state;

-(nullable NSString *)infoTextForState:(UIControlState)state;

-(nullable UIColor *)infoColorForState:(UIControlState)state;

-(nullable UIColor *)infoShadowColorForState:(UIControlState)state;

-(nullable NSAttributedString *)infoAttributedTextForState:(UIControlState)state;

@property (nonatomic, readonly, strong, nullable) NSString *currentInfoText;
@property (nonatomic, readonly, strong, nullable) UIColor *currentInfoColor;
@property (nonatomic, readonly, strong, nullable) UIColor *currentInfoShadowColor;
@property (nonatomic, readonly, strong, nullable) NSAttributedString *currentInfoAttributedText;

@end

NS_ASSUME_NONNULL_END
