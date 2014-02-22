//
//  RDHColorUtils.h
//
//  Created by Richard Hodgkins on 22/02/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#ifndef RDHExpandingPickerViews_RDHColorUtils_h
#define RDHExpandingPickerViews_RDHColorUtils_h

/// RGB - 8 bit [0, 255], A - float, [0,1]
#define UIColorWithRGBA(R, G, B, A) ([UIColor colorWithRed:((R)/255.0) green:((G)/255.0) blue:((B)/255.0) alpha:(A)])
/// RGB - 8 bit [0, 255]
#define UIColorWithRGB(R, G, B) (UIColorWithRGBA((R), (G), (B), 1.0))
/// Gray - 8 bit [0, 255], A - float, [0,1]
#define UIColorWithGrayAlpha(GRAY, A) ([UIColor colorWithWhite:((GRAY)/255.0) alpha:(A)])
/// Gray - 8 bit [0, 255]
#define UIColorWithGray(GRAY) (UIColorWithGrayAlpha((GRAY), 1.0))

#endif
