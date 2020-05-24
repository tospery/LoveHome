//
//  OrderTests.m
//  LoveHome
//
//  Created by Joe Chen on 14/12/17.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HttpServiceManageObject.h"


@interface OrderTests : XCTestCase

@end

@implementation OrderTests

- (void)setUp {
    [super setUp];
   

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testCode
{

    NSDateComponentsFormatter* formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    formatter.includesApproximationPhrase = YES;
    formatter.includesTimeRemainingPhrase = YES;
    formatter.allowedUnits = NSCalendarUnitMinute;
    
    // Use the configured formatter to generate the string.

    

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    
}


- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testBlockVaule
{
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)testdownOrder
{
   
}
@end
