//
//  TOAppRater.m
//
//  Copyright 2021 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TOBorderView.h"

const CGFloat kTOBorderViewDefaultRadius = 25.0f;

@interface TOBorderView ()

// The solid color background view with rounded corners
@property (nonatomic, strong) UIView *backgroundView;

// A container view that wraps all of the custom content
@property (nonatomic, strong, readwrite) UIView *contentView;

// If the background is translucent, cast the background view as an effects view
@property (nonatomic, readonly) UIVisualEffectView *effectsView;

@end

@implementation TOBorderView

#pragma mark - View Lifecycle -

- (instancetype)init
{
    if (self = [super initWithFrame:(CGRect){0, 0, 280, 128}]) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    // Override external configuration to keep this view clear
    [super setBackgroundColor:[UIColor clearColor]];

    // Set default property values
    self.contentInsets = (UIEdgeInsets){25, 25, 25, 25};
    if (@available(iOS 11.0, *)) {
        self.insetsLayoutMarginsFromSafeArea = NO;
    }

    // Configure the solid background view by default
    [self configureSolidBackgroundView];

    // Configure the container view
    self.contentView = [[UIView alloc] initWithFrame: CGRectInset(self.bounds, 20, 20)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [super addSubview:self.contentView];
}

- (void)configureSolidBackgroundView
{
    // Configure a solid background view
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.layer.cornerRadius = kTOBorderViewDefaultRadius;
    if (@available(iOS 13.0, *)) {
        self.backgroundView.layer.cornerCurve = kCACornerCurveContinuous;
    }
    self.backgroundColor = nil; // Force default via null_resettable
    [self insertSubview:self.backgroundView atIndex:0];
}

- (void)configureTranslucentView
{
    // Configure a visual effect view
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:self.translucencyStyle];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.layer.cornerRadius = kTOBorderViewDefaultRadius;
    if (@available(iOS 13.0, *)) {
        effectView.layer.cornerCurve = kCACornerCurveContinuous;
    }
    effectView.layer.masksToBounds = YES;
    effectView.frame = self.bounds;
    self.backgroundView = effectView;
    [self insertSubview:effectView atIndex:0];
}

#pragma mark - View Layout -

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Lay out the background
    self.backgroundView.frame = self.bounds;

    // Detect RTL content layout
    UIUserInterfaceLayoutDirection direction = [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:
                                                self.semanticContentAttribute];
    BOOL isReversedLayout = (direction == UIUserInterfaceLayoutDirectionRightToLeft);

    // Layout the container view to match the insetting
    self.contentView.frame = ({
        UIEdgeInsets insets = self.contentInsets;
        CGRect frame = self.bounds;
        frame.size.width -= (insets.left + insets.right);
        frame.size.height -= (insets.top + insets.bottom);
        frame.origin.y = insets.top;
        frame.origin.x = isReversedLayout ? insets.right : insets.left;
        frame;
    });
}

#pragma mark - View Sizing -

- (void)sizeToFit
{
    // Loop through all of the subviews to build
    // a bounding box containing all of them
    CGRect frame = CGRectZero;

    // Capture all of the child frames so we can restore an auto-resized ones
    NSMutableArray *viewFrames = [NSMutableArray array];

    for (UIView *subview in self.contentView.subviews) {
        frame.size.width = MAX(frame.size.width, CGRectGetMaxX(subview.frame));
        frame.size.height = MAX(frame.size.height, CGRectGetMaxY(subview.frame));
        [viewFrames addObject:[NSValue valueWithCGRect:subview.frame]];
    }

    // Apply to the container view
    self.contentView.frame = frame;

    // Update the frame of the outer view to match
    UIEdgeInsets insets = self.contentInsets;
    CGRect outerFrame = self.frame;
    outerFrame.size.width = (frame.size.width) + (insets.left + insets.right);
    outerFrame.size.height = (frame.size.height) + (insets.top + insets.bottom);
    self.frame = outerFrame;

    // Set needs layout to re-center the container
    [self setNeedsLayout];
    [self layoutIfNeeded];

    // Re-apply the frames to all of the subviews to restore any automatic
    // resizing that happened from auto-resizing properties
    for (NSInteger i = 0; i < self.contentView.subviews.count; i++) {
        UIView *subview = self.contentView.subviews[i];
        subview.frame = [viewFrames[i] CGRectValue];
    }
}

- (void)sizeToFit:(CGSize)fittingSize
{
    UIEdgeInsets insets = self.contentInsets;

    // Adjust for the insets
    CGSize size = fittingSize;
    size.width -= (insets.left + insets.right);
    size.height -= (insets.top + insets.bottom);

    // Adjust the size of every view
    for (UIView *subview in self.contentView.subviews) {
        CGRect frame = subview.frame;
        frame.size = [subview sizeThatFits:size];
        subview.frame = frame;
    }

    // Now call sizeToFit to shrink the border view around this content
    [self sizeToFit];
}

#pragma mark - Child View Management -

- (void)addSubview:(UIView *)view
{
    [self.contentView addSubview:view];
}

- (NSArray<__kindof UIView *> *)subviews
{
    return self.contentView.subviews;
}

- (void)applyContentCornerRadiusToView:(UIView *)view
{
    view.layer.cornerRadius = self.contentCornerRadius;
    if (@available(iOS 13.0, *)) {
        view.layer.cornerCurve = kCACornerCurveCircular;
    }
}

#pragma mark - Accessors -

- (void)setAllContentInsets:(CGFloat)inset
{
    self.contentInsets = UIEdgeInsetsMake(inset, inset, inset, inset);
    [self setNeedsLayout];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    UIColor *newColor = backgroundColor;
    if (backgroundColor == nil) {
        if (@available(iOS 13.0, *)) {
            newColor = [UIColor secondarySystemFillColor];
        } else {
            newColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        }
    }
    self.backgroundView.backgroundColor = newColor;
}

- (UIColor *)backgroundColor { return self.backgroundView.backgroundColor; }

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.backgroundView.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius
{
    return self.backgroundView.layer.cornerRadius;
}

- (CGFloat)contentCornerRadius
{
    // Capture all of the inset values
    UIEdgeInsets insets = self.contentInsets;
    NSArray *insetValues = @[@(insets.top), @(insets.bottom),
                             @(insets.left), @(insets.right)];

    // Fetch the lowest inset value we have
    CGFloat smallestInset = CGFLOAT_MAX;
    for (NSNumber *value in insetValues) {
        if (value.floatValue < smallestInset) {
            smallestInset = value.floatValue;
        }
    }

    // Take the out radius, and return the differences
    return self.cornerRadius - smallestInset;
}

- (void)setIsTranslucent:(BOOL)isTranslucent
{
    if (isTranslucent == _isTranslucent) { return; }

    _isTranslucent = isTranslucent;

    // Remove the existing background from all other strong references
    [self.backgroundView removeFromSuperview];

    // Configure background view content
    if (_isTranslucent) {
        [self configureTranslucentView];
    } else {
        [self configureSolidBackgroundView];
    }

    // Re-layout all the content
    [self setNeedsLayout];
}

- (void)setTranslucencyStyle:(UIBlurEffectStyle)translucencyStyle
{
    if (_translucencyStyle == translucencyStyle) { return; }
    _translucencyStyle = translucencyStyle;
    self.effectsView.effect = [UIBlurEffect effectWithStyle:_translucencyStyle];
}

- (UIVisualEffectView *)effectsView
{
    if ([self.backgroundView isKindOfClass:[UIVisualEffectView class]]) {
        return (UIVisualEffectView *)self.backgroundView;
    }

    return nil;
}

@end
