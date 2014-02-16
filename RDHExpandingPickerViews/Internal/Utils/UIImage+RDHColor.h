//
//  UIImage+RDHColor.h
//
//  Created by Richard Hodgkins on 16/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Category that returns a UIImage filled with the specified color. This could be a cached value.
 * 
 * *N.B.* This cached will be emptied when `UIApplicationDidReceiveMemoryWarningNotification`s are received.
 */
@interface UIImage (RDHColor)

/**
 * This caches the images based on their color.
 *
 * @param color The color to fill the image with. This *must* not be `nil`.
 *
 * @returns A stretchable image of 1x1 points filled with the specified color.
 */
+(instancetype)imageWithColor:(UIColor *)color;

@end
