//
//  TOBorderViewTests.m
//  TOBorderViewTests
//
//  Created by Tim Oliver on 28/8/21.
//

#import <XCTest/XCTest.h>
#import "TOBorderView.h"

@interface TOBorderViewTests : XCTestCase

@end

@implementation TOBorderViewTests

- (void)testBorderView {
    // For now, test we can instantiate the view without issue
    TOBorderView *borderView = [[TOBorderView alloc] init];
    XCTAssertNotNil(borderView);
}

@end
