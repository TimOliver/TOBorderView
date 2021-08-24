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

    self.borderView = [[TOBorderView alloc] initWithFrame:CGRectMake(0, 0, 150, 112)];
    self.borderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.borderView];

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
