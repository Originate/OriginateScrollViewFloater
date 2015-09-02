//
//  OriginateScrollViewFloaterDefaultView.m
//  Originate
//
//  Created by Allen Wu on 7/30/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "OriginateScrollViewFloaterDefaultView.h"
#import "UIColor+ColorAdjustment.h"

const CGFloat kFloaterPaddingX = 20;
const CGFloat kFloaterPaddingY = 10;

@interface OriginateScrollViewFloaterDefaultView ()

@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, strong) UIColor* floaterBackgroundColor;

@property (nonatomic, strong) UILabel* label;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation OriginateScrollViewFloaterDefaultView

#pragma mark - OriginateScrollViewFloaterDefaultView

- (instancetype)initWithTitle:(NSString *)title
                         font:(UIFont *)font
                    textColor:(UIColor *)textColor
              backgroundColor:(UIColor *)backgroundColor
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        _font = font;
        _textColor = textColor;
        _floaterBackgroundColor = backgroundColor;
        
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = self.floaterBackgroundColor;
    
    self.layer.cornerRadius = (MIN(self.label.frame.size.width + kFloaterPaddingX,
                                   self.label.frame.size.height + kFloaterPaddingY)) / 2;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    [self addSubview:self.label];
    
    self.frame = CGRectMake(0,
                            0,
                            self.label.frame.size.width + kFloaterPaddingX,
                            self.label.frame.size.height + kFloaterPaddingY);
    
    self.label.center = self.center;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = self.font;
        _label.text = self.title;
        _label.textColor = self.textColor;
        _label.textAlignment = NSTextAlignmentCenter;
        
        [_label sizeToFit];
        [self invalidateIntrinsicContentSize];
        
    }
    return _label;
}


#pragma mark - UIControl

- (void)setHighlighted:(BOOL)highlighted
{
    self.backgroundColor = highlighted ? [self.floaterBackgroundColor originateFloater_darkerColor] : self.floaterBackgroundColor;
}

@end
