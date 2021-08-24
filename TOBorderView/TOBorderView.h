//
//  TOBorderView.h
//  TOBorderViewExample
//
//  Created by Tim Oliver on 23/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TOBorderView;

/// A protocol that view content inside a `TOBorderView`
/// can conform to in order to receive layout and configuration
/// parameters from the wrapping border view
@protocol TOBorderViewContent <NSObject>

/// When the border view updates its own corner radius value,
/// it can then forward along to the content the equivalent insetted
/// corner radius that the content should apply to itself to match
/// @param borderView The hosting border view
/// @param radius The corner radius the content should apply to match the border view
- (void)borderView:(TOBorderView *)borderView didSetContentCornerRadius:(CGFloat)radius;

@end

/// A hosting view that wraps other UI content to provide
/// a backing border view consisting of a solid fill with rounded corners.
/// The subview hierarchy of the content is internally managed to guarantee the
/// most performant use of Core Animation's corner radius API.
NS_SWIFT_NAME(BorderView)
@interface TOBorderView : UIView

/// The corner radius of the background view. Default is 25 points
@property (nonatomic, assign) CGFloat cornerRadius;

/// The color of the rounded background view. Default is `UIColor.secondaryFill`
@property (nonatomic, strong, null_resettable) UIColor *backgroundColor;

/// Instead of a solid background color, the background is instead
/// a dynamic translucency view. (Default is NO)
@property (nonatomic, assign) BOOL isTranslucent;

/// The translucency style applied to the backround
/// when `isTranslucent` is enabled. (Default is `.regular`)
@property (nonatomic, assign) UIBlurEffectStyle translucencyStyle;

/// Adds a view as a new subview to the border view
/// @param view The view to add a subview to the border view
- (void)addSubview:(UIView *)view;

/// The border view calls `sizeToFit` on all of the subviews, and then
/// resizes itself in order to fit around the child view content based on
/// the current value of `layoutMargins`
- (void)sizeToFit;

/// Given a maximum size, the border view calls `sizeThatFits` on each
/// subview, resizes it to fit, and then resizes itself around the child content
/// based on the current inset values in `layoutMargins`
- (void)sizeToFit:(CGSize)fittingSize;

@end

NS_ASSUME_NONNULL_END
