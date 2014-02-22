//
//  UIImage+RDHColor.m
//
//  Created by Richard Hodgkins on 16/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import "UIImage+RDHColor.h"

@implementation UIImage (RDHColor)

+(NSCache *)colorCache
{
    static NSCache *colorCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorCache = [NSCache new];
        [colorCache setName:[NSString stringWithFormat:@"%@-%@", NSStringFromClass(self), NSStringFromSelector(_cmd)]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    });
    return colorCache;
}

+(void)didReceiveMemoryWarningNotification:(NSNotification *)aNotification
{
    [[self colorCache] removeAllObjects];
}

+(instancetype)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color);
    
    UIImage *cachedImage = [[self colorCache] objectForKey:color];
    if (!cachedImage) {
        cachedImage = [self newImageWithColor:color];
        [[self colorCache] setObject:cachedImage forKey:color];
    }
    return cachedImage;
}

+(instancetype)newImageWithColor:(UIColor *)color
{
    BOOL opaque = CGColorGetAlpha(color.CGColor) == 1;
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 0);
    
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsZero];
}

@end
