//
//  OrderTests.m
//  LoveHome
//
//  Created by MRH on 14/12/17.
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
   
    //    NSArray *list  = @[@400,@350,@400,@500,@600,@400,@400];
    //    NSMutableArray *data = [[NSMutableArray alloc] init];
    //    for (NSNumber *cost in list)
    //    {
    //        StatistChartModel *mode = [[StatistChartModel alloc] init];
    //        mode.cost = [cost floatValue];
    //        [data addObject:mode];
    //    }
    //
    //    RHCharMode *chartModel = [RHCharMode new];
    //    chartModel.chartListData = data;
    //    chartModel.chartFillColor = UIColor.clearColor;
    //
    //    NSArray *list2  = @[@50,@60,@70,@100,@100,@30,@40];
    //    NSMutableArray *data2 = [[NSMutableArray alloc] init];
    //    for (NSNumber *cost in list2)
    //    {
    //        StatistChartModel *mode2 = [[StatistChartModel alloc] init];
    //        mode2.cost = [cost floatValue];
    //        [data2 addObject:mode2];
    //    }
    //
    //    RHCharMode *chartModel2 = [RHCharMode new];
    //    chartModel2.chartListData = data2;
    //    chartModel2.chartFillColor = RHColorHex(0xe4ff00, 1);
    //
    //    NSArray *list3  = @[@100,@205,@230,@125,@220,@125,@220];
    //    NSMutableArray *data3 = [[NSMutableArray alloc] init];
    //    for (NSNumber *cost in list3)
    //    {
    //        StatistChartModel *mode3 = [[StatistChartModel alloc] init];
    //        mode3.cost = [cost floatValue];
    //        [data3 addObject:mode3];
    //    }
    //
    //    RHCharMode *chartModel3 = [RHCharMode new];
    //    chartModel3.chartListData = data3;
    //    chartModel3.chartFillColor = RHColorHex(0x00ff77, 1);
    //
    //    NSArray *list4  = @[@200,@400,@100,@50,@40,@30,@10];
    //    NSMutableArray *data4 = [[NSMutableArray alloc] init];
    //    for (NSNumber *cost in list4)
    //    {
    //        StatistChartModel *mode4 = [[StatistChartModel alloc] init];
    //        mode4.cost = [cost floatValue];
    //        [data4 addObject:mode4];
    //    }
    //
    //    RHCharMode *chartModel4 = [RHCharMode new];
    //    chartModel4.chartListData = data4;
    //    chartModel4.chartFillColor = RHColorHex(0x00ff77, 1);
    //
    //
    //    [_chartList removeAllObjects];
    //    [_chartList addObjectsFromArray:@[chartModel,chartModel2,chartModel3,chartModel4]];
    //    [_orderListhearView.currenDataList removeAllObjects];
    //    [_orderListhearView.currenDataList addObjectsFromArray:@[chartModel,chartModel2,chartModel3,chartModel4]];
    //
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [_orderListhearView resetData];
    //    });
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

// 常用的方法
- (void)testAllowUseFucation {
    // functionManager
    ShowProgressHUD(YES, nil);
    ShowProgressHUD(NO, nil);
    ShowWaringAlertHUD(@"提示", nil);
    
    
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
