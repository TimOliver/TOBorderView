//
//  ViewController.m
//  TOBorderView
//
//  Created by Tim Oliver on 23/8/21.
//

#import "ViewController.h"
#import "TOBorderView.h"

@interface ViewController ()

@property (nonatomic, strong) TOBorderView *borderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Border with text content
    [self makeBorderWithTextContent];

    // Border around image content
    // [self makeBorderWithImageContent];
}

- (void)makeBorderWithImageContent
{
    // Create an "image view" at a predetermined size
    UIView *imageView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 150, 200}];
    imageView.backgroundColor = [UIColor redColor];

    // Create a new border view
    self.borderView = [[TOBorderView alloc] init];

    // Override the insetting to be 10 points
    [self.borderView setAllContentInsets:10];

    // Apply the adjusted corner radius to the image view
    [self.borderView applyContentCornerRadiusToView:imageView];

    // Add the image view to the border view
    [self.borderView addSubview:imageView];

    // Get the border view to size itself around the image view's size
    [self.borderView sizeToFit];

    // Add it to the view controller
    [self.view addSubview:self.borderView];
}

- (void)makeBorderWithTextContent
{
    // Create, configure and add the border view
    self.borderView = [[TOBorderView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    [self.view addSubview:self.borderView];

    // Make a bold variant of title 1 styling
    UIFont *titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    UIFontDescriptor *descriptor = [titleFont.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];

    // Add a label to the border view
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont fontWithDescriptor:descriptor size:0.0f];
    titleLabel.text = @"Hello world!";
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [titleLabel sizeToFit];
    titleLabel.frame = ({
        CGRect frame = titleLabel.frame;
        frame.size.width = self.borderView.contentView.frame.size.width;
        frame;
    });
    [self.borderView addSubview:titleLabel];

    // Make some content text
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    textLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus rhoncus erat at ligula ultrices ullamcorper. ";
    textLabel.numberOfLines = 0;
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textLabel.backgroundColor = [UIColor clearColor];
    [self.borderView addSubview:textLabel];

    textLabel.frame = ({
        CGRect frame = CGRectZero;
        frame.size.width = self.borderView.contentView.frame.size.width;
        frame.size.height = [textLabel sizeThatFits:self.borderView.contentView.frame.size].height;
        frame.origin.y = CGRectGetMaxY(titleLabel.frame) + 5.0f;
        frame;
    });

    // Scale the border view around the text
    [self.borderView sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Remove the title bar in Mac Catalyst
#if TARGET_OS_MACCATALYST
    UIWindowScene *scene = self.view.window.windowScene;
    scene.titlebar.titleVisibility = UITitlebarTitleVisibilityHidden;
    scene.titlebar.toolbar = nil;
#endif
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.borderView.center = self.view.center;
}

@end
