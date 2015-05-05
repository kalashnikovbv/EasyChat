//
//  iOSChatTests.m
//  iOSChatTests
//
//  Created by Bogdan on 4/11/15.
//  Copyright (c) 2015 Bogdan Kalashnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface iOSChatTests : XCTestCase

@end

@implementation iOSChatTests

- (void) setUp
{
    [super setUp];
    // This method is called before the invocation of each test method in the class.
}

- (void) tearDown
{
    // This method is called after the invocation of each test method in the class.
    
    [super tearDown];
}

- (void) testExample
{
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void) testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock: ^
    {
        // Put the code you want to measure the time of here.
    }];
}

@end
