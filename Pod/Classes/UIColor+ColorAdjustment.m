//
//  UIColor+ColorAdjustment.m
//  Originate
//
//  Created by Allen Wu on 8/13/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "UIColor+ColorAdjustment.h"

@implementation UIColor (ColorAdjustment)

- (UIColor *)originateFloater_darkerColor
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    }
    return self;
}

@end
