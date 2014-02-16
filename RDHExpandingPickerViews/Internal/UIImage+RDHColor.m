//
//  UIImage+RDHColor.m
//  RDHExpandingPickerViews
//
//  Created by Richard Hodgkins on 16/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "UIImage+RDHColor.h"

@implementation UIImage (RDHColor)

+(instancetype)imageWithColor:(UIColor *)color
{
    BOOL opaque = CGColorGetAlpha(color.CGColor) == 1;
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 0);
    
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
}

@end
