//
//  OriginateScrollViewFloater.h
//  Originate
//
//  Created by Allen Wu on 7/30/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

@import UIKit;
#import "OriginateScrollViewFloaterDefaultView.h"

typedef void (^OriginateScrollViewFloaterTapHandler)(void);

typedef NS_ENUM(NSUInteger, OriginateScrollViewFloaterDirection) {
    OriginateScrollViewFloaterDirectionTop,
    OriginateScrollViewFloaterDirectionBottom,
    OriginateScrollViewFloaterDirectionLeft,
    OriginateScrollViewFloaterDirectionRight,
};

NS_ASSUME_NONNULL_BEGIN

@interface OriginateScrollViewFloater : UIView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                       floaterView:(UIControl *)floaterView;

- (void)showAtContentOffset:(CGPoint)appearanceOffset
              fromDirection:(OriginateScrollViewFloaterDirection)direction
        hideWhenApproaching:(CGPoint)disappearanceOffset
                 tapHandler:(OriginateScrollViewFloaterTapHandler)tapHandler;

@end

NS_ASSUME_NONNULL_END
