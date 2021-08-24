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
@property (nonatomic, strong) UIView *containerView;

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
    self.cornerRadius = 25.0f;


    // Configure background view
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundColor = nil; // Force default via null_resettable
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

@end
