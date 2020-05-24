//
//  IncomeDetailsHearView.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "IncomeDetailsHearView.h"
#import "Chameleon.h"
#define kLableFont [UIFont systemFontOfSize:11]
#define kTopSpace 30
#define kBootmSpace 25
#define kLeftSapce 30

@interface IncomeDetailsHearView ()
@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) CAShapeLayer *pointLayer;
@property (nonatomic,strong) CAShapeLayer *bottomLayer;
@property (nonatomic,strong) UILabel *starxLable;
@property (nonatomic,strong) UILabel *endxLable;
@property (nonatomic,strong) UILabel *priceLable;
@property (nonatomic,strong) UILabel *starYmoney;
@property (nonatomic,strong) UILabel *starMaxYmoney;

@end


@implementation IncomeDetailsHearView

- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpXY];
        
    }
    return self;
}

- (void)setUpXY
{
    
    self.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.bounds andColors:@[[UIColor flatRedColor],[UIColor flatRedColor],[UIColor redColor]]];
    
    
    CAShapeLayer *line = [CAShapeLayer layer];
    line.strokeColor = [UIColor whiteColor].CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *zuoBiao = [[UIBezierPath alloc] init];
    [zuoBiao moveToPoint:CGPointMake(kLeftSapce, kTopSpace)];
    [zuoBiao addLineToPoint:CGPointMake(kLeftSapce, self.height - kBootmSpace)];
    [zuoBiao addLineToPoint:CGPointMake(kLeftSapce, self.height - kBootmSpace)];
    [zuoBiao addLineToPoint:CGPointMake(self.width - kLeftSapce, self.height - kBootmSpace)];

    line.path = zuoBiao.CGPath;

    [self.layer addSublayer:line];
//    line.strokeEnd = 0;    
//    
//    CABasicAnimation *animtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animtion.duration = 3;
//    animtion.fromValue = @0;
//    animtion.toValue = @1.0;
//
//    
//    CABasicAnimation *animtion2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
//    animtion2.beginTime = 0.23;
//    animtion2.duration = 2.77;
//    animtion2.fromValue = @0;
//    animtion2.toValue = @1.0;
//
//
//        
//        
//    CAAnimationGroup *grou = [CAAnimationGroup animation];
//    grou.animations = @[animtion,animtion2];
//    grou.duration = 3;
//    [line addAnimation:grou forKey:@"grou"];
    
    
    
    UILabel *xTitle = [[UILabel alloc] init];
    xTitle.textColor = [UIColor whiteColor];
    xTitle.frame = CGRectMake(0, 16, kLeftSapce *2, 10);
    xTitle.font = kLableFont;
    xTitle.textAlignment = NSTextAlignmentCenter;
    xTitle.text = @"近7日收入";
    [self addSubview:xTitle];
    
    
    UILabel *xEnd = [[UILabel alloc] init];
    xEnd.frame = CGRectMake(self.width - 200, 16, 180, 10);
    xEnd.textColor = [UIColor whiteColor];
    xEnd.font = kLableFont;
    xEnd.textAlignment = NSTextAlignmentRight;
    xEnd.text = @"近7日收入:0.0";
    self.priceLable = xEnd;
    [self addSubview:_priceLable];

    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM月dd日"];
    NSString *now = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *old = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7]];
    
    
    UILabel *starLbale = [[UILabel alloc] init];
    starLbale.frame = CGRectMake(0, self.height - 24, 85, 24);
    starLbale.textAlignment = NSTextAlignmentCenter;
    starLbale.font = kLableFont;
    starLbale.textColor = [UIColor whiteColor];
#pragma mark - 修复 显示时间label 前
    starLbale.text = now;
    self.starxLable = starLbale;
    [self addSubview:_starxLable];
    
    
    UILabel *endLbale = [[UILabel alloc] init];
    endLbale.frame = CGRectMake(self.width - 80, self.height - 24, 85, 24);
    endLbale.textAlignment = NSTextAlignmentCenter;
    endLbale.font = kLableFont;
    endLbale.textColor = [UIColor whiteColor];
#pragma mark - 修复 显示时间label 后
    endLbale.text = old;
    self.endxLable = endLbale;
    [self addSubview:_endxLable];
    

    UILabel *starYMoney = [[UILabel alloc] init];
    starYMoney.frame = CGRectMake(0, self.height - kBootmSpace - 15, kLeftSapce - 3, 24);
    starYMoney.textAlignment = NSTextAlignmentRight;
    starYMoney.font = [UIFont systemFontOfSize:10];
    starYMoney.textColor = [UIColor whiteColor];
    //starYMoney.text = @"￥0";

    self.starYmoney = starYMoney;
#pragma mark - 将最小价格label 显示出来
    [self addSubview:_starYmoney];
    
    UILabel *starMaxYMoney = [[UILabel alloc] init];
    starMaxYMoney.frame = CGRectMake(0,kBootmSpace + 10, kLeftSapce - 3, 24);
    starMaxYMoney.textAlignment = NSTextAlignmentRight;
    starMaxYMoney.font = [UIFont systemFontOfSize:10];
    starMaxYMoney.textColor = [UIColor whiteColor];
   // starMaxYMoney.text = @"￥0";
    self.starMaxYmoney = starMaxYMoney;
#pragma mark - 将最大价格label 显示出来
    [self addSubview:_starMaxYmoney];
    
    
    
}

- (void)dataSource:(NSArray *)dataSource
{
    [_bottomLayer removeFromSuperlayer];
    [_lineLayer removeFromSuperlayer];
    [_pointLayer removeFromSuperlayer];
    
    dataSource = [[dataSource reverseObjectEnumerator] allObjects];
    if (JudgeContainerCountIsNull(dataSource)) {
        
        ShowWaringAlertHUD(@"占无收入数据", self);
        return;
    }
    
    CGFloat allHeight = self.height - kTopSpace - kBootmSpace;
    // 实际显示高度
    CGFloat contenHeight = allHeight - 20;
    CGFloat oneW  = (self.width - 10 - kLeftSapce *2) / (dataSource.count -1);
    CGFloat startY = self.height - kBootmSpace - 10;
    CGFloat starX = kLeftSapce;
    
    
    _bottomLayer = [CAShapeLayer layer];
    _bottomLayer.strokeColor   = [UIColor whiteColor].CGColor;
    _bottomLayer.fillColor     = [UIColor clearColor].CGColor;
    _bottomLayer.lineCap       = kCALineCapSquare;
    _bottomLayer.lineWidth = 1.0;
    _bottomLayer.opacity = 0.3;
    _bottomLayer.fillColor = nil;
    _bottomLayer.lineDashPattern = @[@2, @2];

    [self.layer addSublayer:_bottomLayer];

    
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.strokeColor   = [UIColor whiteColor].CGColor;
    _lineLayer.fillColor     = [UIColor clearColor].CGColor;
    _lineLayer.lineCap       = kCALineCapSquare;
    _lineLayer.lineWidth = 1.0;
    [self.layer addSublayer:_lineLayer];
    
    _pointLayer= [CAShapeLayer layer];
    _pointLayer.strokeColor   = [UIColor whiteColor].CGColor;
    _pointLayer.fillColor     = [UIColor flatRedColor].CGColor;
    _pointLayer.lineCap       = kCALineCapSquare;
    _pointLayer.lineWidth = 1.0;
    [self.layer addSublayer:_pointLayer];
    
    
    
    // YJX_TODO 临时解决crash
    CGFloat maxDayValue = [[dataSource.firstObject objectForKey:@"cash"] floatValue];
    CGFloat minDayValue = [[dataSource.firstObject objectForKey:@"cash"] floatValue];
    CGFloat allValue = 0.00;
    NSString *endTime = [dataSource.lastObject objectForKey:@"dealDate"];
    NSString *minTime = [dataSource.firstObject objectForKey:@"dealDate"];
    
    //最大值 最小值
    for (NSDictionary *value in dataSource) {
        CGFloat vlues = [[value objectForKey:@"cash"] floatValue];
        if (vlues > maxDayValue) {
            maxDayValue = vlues;
            endTime = [value objectForKey:@"dealDate"];
        }
        
        if (vlues < minDayValue) {
            minDayValue = vlues;
            minTime = [value objectForKey:@"dealDate"];
        }
        allValue += vlues;

    }
    
    _starxLable.text =  dataSource.firstObject[@"dealDate"];
    _endxLable.text  =  dataSource.lastObject[@"dealDate"];
    _starYmoney.text =[NSString stringWithFormat:@"￥%.2lf",minDayValue];
    _starMaxYmoney.text = [NSString stringWithFormat:@"￥%.2lf",maxDayValue];
    _priceLable.text = [NSString stringWithFormat:@"近7日收入:￥%.2lf",allValue];
    // TODO 减最小值
    CGFloat space = maxDayValue - minDayValue;
    
    CGFloat oneceValue = space == 0 ? 0 : contenHeight / space;
    
    int i =0;
    
    NSMutableArray *points = [NSMutableArray array];
    for (NSDictionary *price in dataSource)
    {
        
        
        CGFloat value = [[price objectForKey:@"cash"] floatValue];
        CGFloat Y  =  startY - (value - minDayValue) * oneceValue;
        CGFloat X  = starX + oneW *i;
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(X, Y)];
        i ++;
        [points addObject:pointValue];
    }
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *pointPaht = [UIBezierPath bezierPath];
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    for (int i = 0; i<points.count; i++) {
        NSValue *vluew = points[i];
        CGPoint point = [vluew CGPointValue];
        if (i == 0) {
            [path moveToPoint:point];
        }
        else
        {
//            [bottomPath moveToPoint:CGPointMake(point.x ,startY + 10)];
//            [bottomPath addLineToPoint:CGPointMake(point.x,kTopSpace + 5)];
            
            [path addLineToPoint:point];
            
        }
        
        [pointPaht moveToPoint:CGPointMake(point.x + 3, point.y)];
        [pointPaht addArcWithCenter:point radius:3.0 startAngle:0 endAngle:2.0 * M_PI clockwise:YES];
        
    }
    _bottomLayer.path = bottomPath.CGPath;
    _lineLayer.path = path.CGPath;
    _pointLayer.path = pointPaht.CGPath;
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_lineLayer addAnimation:pathAnimation forKey:@"lineAnimation"];
    
    CABasicAnimation *pathAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation2.duration = 1.1;
    pathAnimation2.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation2.toValue = [NSNumber numberWithFloat:1.0f];
//    pathAnimation2.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [_pointLayer addAnimation:pathAnimation2 forKey:@"pointAnimation"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

@end
