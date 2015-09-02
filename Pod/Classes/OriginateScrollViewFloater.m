//
//  OriginateScrollViewFloater.m
//  Originate
//
//  Created by Allen Wu on 7/30/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "OriginateScrollViewFloater.h"

CGFloat const kFloaterMargin = 40;

NS_ASSUME_NONNULL_BEGIN

@interface OriginateScrollViewFloater ()

@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, strong) UIControl* floaterView;

@property (nonatomic, copy, nullable) OriginateScrollViewFloaterTapHandler tapHandler;
@property (nonatomic, assign) OriginateScrollViewFloaterDirection direction;
@property (nonatomic, assign) CGPoint appearanceOffset;
@property (nonatomic, assign) CGPoint disappearanceOffset;

@property (nonatomic, assign, getter=isVisible) BOOL visible;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

@end

NS_ASSUME_NONNULL_END


@implementation OriginateScrollViewFloater

#pragma mark - UIView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(self.floaterView.frame, point);
}


#pragma mark - OriginateScrollViewFloater

- (instancetype)initWithScrollView:(nonnull UIScrollView *)scrollView
                       floaterView:(nonnull UIControl *)floaterView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _scrollView = scrollView;
        _floaterView = floaterView;
        
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.clipsToBounds = YES;
    
    self.floaterView.alpha = 0;
    
    [self.floaterView addTarget:self action:@selector(floaterTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.floaterView];
}

- (void)showAtContentOffset:(CGPoint)appearanceOffset
              fromDirection:(OriginateScrollViewFloaterDirection)direction
        hideWhenApproaching:(CGPoint)disappearanceOffset
                 tapHandler:(OriginateScrollViewFloaterTapHandler)tapHandler
{
    self.direction = direction;
    self.appearanceOffset = appearanceOffset;
    self.disappearanceOffset = disappearanceOffset;
    self.tapHandler = tapHandler;
    
    self.enabled = YES;
    
    [self showOrHide];
}


#pragma mark - Internal

- (BOOL)shouldShowFloater
{
    switch (self.direction) {
        case OriginateScrollViewFloaterDirectionTop:
            return self.scrollView.contentOffset.y >= self.appearanceOffset.y;
            
        case OriginateScrollViewFloaterDirectionBottom:
            return self.scrollView.contentOffset.y <= self.appearanceOffset.y;
            
        case OriginateScrollViewFloaterDirectionLeft:
            return self.scrollView.contentOffset.x >= self.appearanceOffset.x;
            
        case OriginateScrollViewFloaterDirectionRight:
            return self.scrollView.contentOffset.x <= self.appearanceOffset.x;
    }
}

- (void)showOrHide
{
    if (!self.isEnabled) {
        return;
    }
    
    if ([self shouldShowFloater]) {
        if (!self.isVisible) {
            [self show];
        }
    }
    else {
        [self hide];
    }
}

- (void)show
{
    self.visible = YES;
    
    self.floaterView.alpha = 1;
    self.floaterView.center = [self centerForHiddenFloaterInDirection:self.direction];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.floaterView.center = [self centerForVisibleFloaterInDirection:self.direction];
    }];
}

- (void)hide
{
    self.visible = NO;
    self.enabled = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.floaterView.alpha = 0;
        self.floaterView.center = [self centerForHiddenFloaterInDirection:self.direction];
    }];
}

- (CGPoint)centerForVisibleFloaterInDirection:(OriginateScrollViewFloaterDirection)direction
{
    switch (self.direction) {
        case OriginateScrollViewFloaterDirectionTop:
            return CGPointMake(self.center.x, kFloaterMargin);
            
        case OriginateScrollViewFloaterDirectionBottom:
            return CGPointMake(self.center.x, self.scrollView.frame.size.height - kFloaterMargin);
            
        case OriginateScrollViewFloaterDirectionLeft:
            return CGPointMake(kFloaterMargin, self.center.y);
            
        case OriginateScrollViewFloaterDirectionRight:
            return CGPointMake(self.scrollView.frame.size.width - kFloaterMargin, self.center.y);
    }
}

- (CGPoint)centerForHiddenFloaterInDirection:(OriginateScrollViewFloaterDirection)direction
{
    switch (self.direction) {
        case OriginateScrollViewFloaterDirectionTop:
            return CGPointMake(self.center.x, -self.floaterView.frame.size.height / 2);
            
        case OriginateScrollViewFloaterDirectionBottom:
            return CGPointMake(self.center.x, self.scrollView.frame.size.height + (self.floaterView.frame.size.height / 2));
            
        case OriginateScrollViewFloaterDirectionLeft:
            return CGPointMake(-self.floaterView.frame.size.width / 2, self.center.y);
            
        case OriginateScrollViewFloaterDirectionRight:
            return CGPointMake(self.scrollView.frame.size.width + (self.floaterView.frame.size.width / 2), self.center.y);
    }
}


#pragma mark - KVO

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (self.superview) {
        [self removeObserversFromView:self.scrollView];
    }
    
    if (newSuperview) {
        [self addScrollViewObservers:self.scrollView];
    }
}


- (void)removeObserversFromView:(UIView *)view
{
    NSParameterAssert([view isKindOfClass:[UIScrollView class]]);
    
    [view removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

- (void)addScrollViewObservers:(UIView *)view
{
    NSParameterAssert([view isKindOfClass:[UIScrollView class]]);
    
    [view addObserver:self
           forKeyPath:NSStringFromSelector(@selector(contentOffset))
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
}


#pragma mark - Actions

- (void)floaterTapped:(id)sender
{
    [self hide];
    
    if (self.tapHandler) {
        self.tapHandler();
    }
}


#pragma mark - UIScrollView observing

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    [self showOrHide];
}

@end
