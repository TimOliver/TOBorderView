//
//  TOBorderView.m
//  TOBorderViewExample
//
//  Created by Tim Oliver on 23/8/21.
//

#import "TOBorderView.h"

@interface TOBorderView ()

// The solid color background view with rounded corners
@property (nonatomic, strong) UIView *backgroundView;

// A container view that wraps all of the custom content
@property (nonatomic, strong, readwrite) UIView *contentView;

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
    self.contentInsets = (NSDirectionalEdgeInsets){20, 20, 20, 20};
    self.insetsLayoutMarginsFromSafeArea = NO;

    // Configure background view
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.layer.cornerRadius = 25.0f;
    self.backgroundView.layer.cornerCurve = kCACornerCurveContinuous;
    self.backgroundColor = nil; // Force default via null_resettable
    [super addSubview:self.backgroundView];

    // Configure the container view
    self.contentView = [[UIView alloc] initWithFrame: CGRectInset(self.bounds, 20, 20)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [super addSubview:self.contentView];
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
        NSDirectionalEdgeInsets insets = self.contentInsets;
        CGRect frame = self.bounds;
        frame.size.width -= (insets.leading + insets.trailing);
        frame.size.height -= (insets.top + insets.bottom);
        frame.origin.y = insets.top;
        frame.origin.x = isReversedLayout ? insets.trailing : insets.leading;
        frame;
    });
}

#pragma mark - View Sizing -

- (void)sizeToFit
{
    // Loop through all of the subviews to build
    // a bounding box containing all of them
    CGRect frame = CGRectZero;

    for (UIView *subview in self.contentView.subviews) {
        frame.size.width = MAX(frame.size.width, CGRectGetMaxX(subview.frame));
        frame.size.height = MAX(frame.size.height, CGRectGetMaxY(subview.frame));
    }

    // Apply to the container view
    self.contentView.frame = frame;

    // Update the frame of the outer view to match
    NSDirectionalEdgeInsets insets = self.contentInsets;
    CGRect outerFrame = self.frame;
    outerFrame.size.width = (frame.size.width) + (insets.leading + insets.trailing);
    outerFrame.size.height = (frame.size.height) + (insets.top + insets.bottom);
    self.frame = outerFrame;

    // Set needs layout to re-center the container
    [self setNeedsLayout];
    [self layoutIfNeeded];
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

#pragma mark - Accessors -

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    UIColor *newColor = backgroundColor;
    if (backgroundColor == nil) {
        newColor = [UIColor secondarySystemFillColor];
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

@end
