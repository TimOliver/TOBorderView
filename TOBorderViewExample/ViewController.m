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

    // Create, configure and add the border view
    self.borderView = [[TOBorderView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    self.borderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
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
        frame.origin.y = CGRectGetMaxY(titleLabel.frame) + 20.0f;
        frame;
    });

    [self.borderView sizeToFit];

    // Move to the center
    self.borderView.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Remove the title bar in Mac Catalyst
    UIWindowScene *scene = self.view.window.windowScene;
    scene.titlebar.titleVisibility = UITitlebarTitleVisibilityHidden;
    scene.titlebar.toolbar = nil;
}

@end
