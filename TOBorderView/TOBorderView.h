//
//  TOAppRater.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TOBorderView;

/// A hosting view that wraps other UI content inside
/// a backing view consisting of a solid fill with rounded corners.
/// The subview hierarchy of the content is internally managed to guarantee the
/// most performant use of Core Animation's corner radius API.
NS_SWIFT_NAME(BorderView)
@interface TOBorderView : UIView

/// The corner radius of the background view. Default is 25 points
@property (nonatomic, assign) CGFloat cornerRadius;

/// The amount of insetting between the content and the edge of the border (Default is 20 points each)
@property (nonatomic, assign) NSDirectionalEdgeInsets contentInsets;

/// The corner radius that can be applied to internal content so it aligns with the border
@property (nonatomic, readonly) CGFloat contentCornerRadius;

/// The color of the rounded background view. Default is `UIColor.secondaryFill`
@property (nonatomic, strong, null_resettable) UIColor *backgroundColor;

/// A reference to the container view that hosts all of the content that can be used for sizing
@property (nonatomic, readonly) UIView *contentView;

/// Instead of a solid background color, the background is instead
/// a dynamic translucency view. (Default is NO)
@property (nonatomic, assign) BOOL isTranslucent;

/// The translucency style applied to the backround
/// when `isTranslucent` is enabled. (Default is `.regular`)
@property (nonatomic, assign) UIBlurEffectStyle translucencyStyle;

/// Adds a view as a new subview to the border view
/// @param view The view to add a subview to the border view
- (void)addSubview:(UIView *)view;

/// Calculates the bounding box size of all subviews inside the border view
/// and then resize the border view to wrap around that bounding box.
- (void)sizeToFit;

/// Given a maximum size, the border view calls `sizeThatFits` on each
/// subview, resizes it to fit, and then resizes itself around the child content
/// based on the current inset values in `layoutMargins`
- (void)sizeToFit:(CGSize)fittingSize;

/// For convenience, sets all of the content inset values to the provided value
- (void)setAllContentInsets:(CGFloat)inset;

/// Automatically configures the provided view with the necessary corner radius and curve
/// to match this border view
- (void)applyContentCornerRadiusToView:(UIView *)view NS_SWIFT_NAME(applyContentCornerRadius(to:));

@end

NS_ASSUME_NONNULL_END
