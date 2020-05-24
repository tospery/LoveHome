//
//  HomeViewCtroller.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/5.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "HomeViewCtroller.h"
#import "DetailViewController.h"

@interface HomeViewCtroller ()

@end

@implementation HomeViewCtroller


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];


}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"123123";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(30, 100, 100, 30);
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"sd" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonpress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //
    [self drawLine];

    // Do any additional setup after loading the view.
}



- (void)drawLine
{
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor   = [UIColor grayColor].CGColor;   // 边缘线的颜色
    lineLayer.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    lineLayer.lineCap       = kCALineCapSquare;               // 边缘线的类型
    lineLayer.lineWidth = 2.0;
    lineLayer.strokeEnd = 0;
    [self.view.layer addSublayer:lineLayer];
    
    CAShapeLayer *PointLayer = [CAShapeLayer layer];
    PointLayer.strokeColor   = [UIColor grayColor].CGColor;   // 边缘线的颜色
    PointLayer.fillColor     = [UIColor whiteColor].CGColor;   // 闭环填充的颜色
    PointLayer.lineCap       = kCALineCapSquare;               // 边缘线的类型
    PointLayer.lineWidth = 2.0;
    PointLayer.strokeEnd = 0;
    [self.view.layer addSublayer:PointLayer];
    
    
    NSMutableArray *points = [NSMutableArray array];
    
    
    
    NSValue *point1 = [NSValue valueWithCGPoint:CGPointMake(30, 64)];
    NSValue *point2 = [NSValue valueWithCGPoint:CGPointMake(80, 150)];
    NSValue *point3 = [NSValue valueWithCGPoint:CGPointMake(150, 80)];
    [points addObject:point1];
    [points addObject:point2];
    [points addObject:point3];
    
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *pointPath = [UIBezierPath bezierPath];
    for (int i = 0; i<points.count; i++) {
        NSValue *vluew = points[i];
        CGPoint point = [vluew CGPointValue];
        if (i == 0) {
            [path moveToPoint:point];
        }
        else
        {
            [path addLineToPoint:point];
        }
        
        // 此处必须加半径
        [pointPath moveToPoint:CGPointMake(point.x + 3.0, point.y)];
        [pointPath addArcWithCenter:point radius:3.0 startAngle:0 endAngle:2.0 * M_PI clockwise:YES];
        
    }
    lineLayer.path = path.CGPath;
    PointLayer.path = pointPath.CGPath;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        lineLayer.speed       = 0.1;
        lineLayer.strokeEnd   = 1.0f;
        PointLayer.speed   = 0.1;
        PointLayer.strokeEnd   = 1.0f;

    });
    
}


- (void)buttonpress:(UIButton *)sneder
{
    DetailViewController  *vc = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
