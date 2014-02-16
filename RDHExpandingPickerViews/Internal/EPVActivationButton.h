//
//  EPVActivationButton.h
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 15/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN const UIControlState UIControlStateActivated;

@interface EPVActivationButton : UIButton

@property (nonatomic, assign, getter = isActivated) BOOL activated;

@property (nonatomic, assign) UIEdgeInsets labelEdgeInsets;

@property (nonatomic, weak, readonly) UILabel *infoLabel;

@end
