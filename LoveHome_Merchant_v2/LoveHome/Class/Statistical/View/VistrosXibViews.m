//
//  VistrosXibViews.m
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "VistrosXibViews.h"
#import "Chameleon.h"
#import "RHCharMode.h"
#import "StatistChartModel.h"

@interface VistrosXibViews ()

@property (nonatomic, weak) IBOutlet UIView  *contentView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *lableX;
@property (nonatomic, weak) IBOutlet UILabel *lableY;
@property (nonatomic, weak) IBOutlet UILabel * titleLab;
@property (nonatomic, weak) IBOutlet UILabel * startDateLab;
@property (nonatomic, weak) IBOutlet UILabel * endDateLab;
@property (nonatomic, weak) IBOutlet UILabel * rightLab;

@property (nonatomic,strong) NSMutableArray *layerList;
@property (nonatomic,strong) NSMutableArray *pointLayerList;

@property (nonatomic,assign) CGFloat starY;
@property (nonatomic,assign) CGFloat starX;
@property (nonatomic,assign) CGFloat allWidth;
@property (nonatomic,assign) CGFloat allHeight;
@property (nonatomic,assign) CGFloat minDayValue;
@property (nonatomic,assign) CGFloat maxDayValue;
@property (nonatomic,assign) CGFloat onceSpaceValue;




@end

@implementation VistrosXibViews

- (void)awakeFromNib{
    
    [self initData];
    [self setUpSubViss];
    
    [self configContentBackgroudColor:RHColorHex(0xf3bb8a, 1) end:RHColorHex(0xF17FA5, 1)];

    _titleLab.font = RHFontAdap(13);
    _startDateLab.font = RHFontAdap(13);
    _endDateLab.font = RHFontAdap(13);
    _rightLab.font = RHFontAdap(13);

    
}

- (void)configContentBackgroudColor:(UIColor *)first end:(UIColor *)end{
    
    self.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.bounds andColors:@[first,end]];
}

- (void)initData{
    
    self.layerList      = [[NSMutableArray alloc] init];
    self.pointLayerList = [[NSMutableArray alloc] init];
    self.currenDataList = [[NSMutableArray alloc] init];
    
}

- (void)setUpSubViss{
    // IBoutlet View
  
    // block
}


- (void)resetData{
    _minDayValue = 10000000.0f;
    _maxDayValue = 0.0;
    [self reloadDataView];
}

- (void)reloadDataView{
    
    // TODO 配置相关的title信息
    [self congfigRightLableTitle];
    for (int i = 0; i< _layerList.count; i++) {
        CAShapeLayer *linLayer = _layerList[i];
        CAShapeLayer *point = _pointLayerList[i];
        [linLayer removeFromSuperlayer];
        [point removeFromSuperlayer];
    }
    
    [_layerList removeAllObjects];
    [_pointLayerList removeAllObjects];
    
    _allWidth = _contentView.bounds.size.width - 10;
    _allHeight = _contentView.bounds.size.height - 10;
    
    // caluateAllValues Sapce OneceValue
    for ( RHCharMode *chartModel in _currenDataList){
        
        [self getCalculateMaxValueWithMin:chartModel.chartListData];
    }
    
    CGFloat space = _maxDayValue - _minDayValue;
    CGFloat once = space == 0 ? 0 : (_allHeight - 5) / space;
    _onceSpaceValue = once;
    
    
    CGFloat maxContentW = _contentView.width;
    
    for  (RHCharMode *chartModel in _currenDataList)
    {
        CGFloat scale = chartModel.chartListData.count / 30.0f;
        
        // scorllView contentSize
        CGFloat contentW = chartModel.chartListData.count < 30 ?_contentView.width :_contentView.width  * scale;
        
        if (contentW > maxContentW)
        {
            maxContentW = contentW;
        }
        // reset Layer
        CAShapeLayer  *linLayer   = [CAShapeLayer layer];
        CAShapeLayer  *pointLayer = [CAShapeLayer layer];
        linLayer.lineWidth = 0.7;
        linLayer.strokeColor = RHColorHex(0xFFFFFF,0.8).CGColor;
        pointLayer.strokeColor = UIColor.whiteColor.CGColor;
        pointLayer.lineWidth = 0.7;
        linLayer.fillColor   = UIColor.clearColor.CGColor;
        pointLayer.fillColor = chartModel.chartFillColor.CGColor;
        
        
        // Begin DrawLine caluateAllValues opoint
        NSArray *points = [self getAllPointsWithValue:chartModel.chartListData];
        UIBezierPath *pointBezier = [UIBezierPath bezierPath];
        UIBezierPath *lintBezier  = [UIBezierPath bezierPath];
        __block CGFloat x  = 0.0;
        __block CGFloat y  = 0.0;
        __block  CGFloat last_x  = 0.0;
        __block  CGFloat last_y  = 0.0;
        
        CGFloat raudis  = points.count > 7 ? 1.8 : 3;
        
        [points enumerateObjectsUsingBlock:^(NSValue  *_Nonnull ji, NSUInteger index, BOOL * _Nonnull stop) {
            CGPoint value = [ji CGPointValue];
            x = value.x;
            y = value.y;
            if (index == 0) {
                [lintBezier moveToPoint:CGPointMake(value.x, value.y)];
            }
            else
            {
                CGFloat distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2));
                CGFloat  last_x1  = last_x + (raudis ) / distance * (x - last_x);
                CGFloat  last_y1   = last_y + (raudis) / distance * (y - last_y);
                CGFloat   x1  = x - (raudis) / distance * (x - last_x);
                CGFloat   y1  = y - (raudis ) / distance * (y - last_y);
                [lintBezier moveToPoint:CGPointMake(last_x1,last_y1)];
                [lintBezier addLineToPoint:CGPointMake(x1,y1)];
            }
            last_x = x;
            last_y = y;
            [pointBezier moveToPoint:CGPointMake(value.x + raudis, value.y)];
            [pointBezier addArcWithCenter:CGPointMake(value.x, value.y) radius:raudis startAngle:0 endAngle:(M_PI) * 2.0 clockwise:YES];
        }];
        linLayer.path = lintBezier.CGPath;
        pointLayer.path = pointBezier.CGPath;
        [_scrollView.layer addSublayer:linLayer];
        [_scrollView.layer addSublayer:pointLayer];
        [_layerList addObject:linLayer];
        [_pointLayerList addObject:pointLayer];
        
    }
    _scrollView.contentSize = CGSizeMake(maxContentW, _scrollView.height);
}


// OnceSpaceValue
- (void)getCalculateMaxValueWithMin:(NSArray *)datalist
{
    StatistChartModel *mode = [datalist lastObject];
    CGFloat max  = mode.cost;
    CGFloat min  = 1000000.00;
    CGFloat allValue  = 0.0;
    for (StatistChartModel*statistCharModel in datalist)
    {
        CGFloat vlues = statistCharModel.cost;
        if (vlues > max) {
            max = vlues;
        }
        
        if (vlues < min) {
            min = vlues;
        }
        allValue+=vlues;
    }
    _maxDayValue = max > _maxDayValue ? max : _maxDayValue;
    _minDayValue = min < _minDayValue ? min : _minDayValue;
    
}


// Get Draw Points
- (NSArray *)getAllPointsWithValue:(NSArray *)data
{
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    CGFloat widthSp  = data.count > 30 ? _allWidth  / 29.0: _allWidth / (data.count - 1);
    
    for (int index = 0;index < data.count ;index ++)
    {
        StatistChartModel *value = data[index];
        
        CGFloat values = value.cost;
        CGFloat Y  = _allHeight - (values - _minDayValue) * _onceSpaceValue;
        CGFloat X  = 3 + widthSp * index;
        CGPoint pointElement = CGPointMake(X, Y);
        [points addObject:[NSValue valueWithCGPoint:pointElement]];
        
    }
    return points;
}


// 配置XY显示
- (void)congfigRightLableTitle {
    RHCharMode *charMode = [_currenDataList lastObject];
    StatistChartModel *starModel = charMode.chartListData.firstObject;
    StatistChartModel *endModel = charMode.chartListData.lastObject;
    
    NSLog(@"_startDateLab.text ===== %@, _endDateLab ===== %@", starModel.valueDate, endModel.valueDate);
    
//    if (_chartType == VistrosCount) {
//        _startDateLab.text = endModel.valueDate;
//        _endDateLab.text = starModel.valueDate;
//    } else {
    _startDateLab.text = starModel.valueDate;
    _endDateLab.text = endModel.valueDate;
   // }
    
//    _startDateLab.text = endModel.valueDate;
//    _endDateLab.text = starModel.valueDate;
    
}

#pragma mark - 根据进入页面的不同, label显示不同的文字
- (void)setChartType:(CharType)chartType
{
    _chartType  = chartType;

    if (_chartType == VistrosCount){
        [self configContentBackgroudColor:RHColorHex(0xf3bb8a, 1) end:RHColorHex(0xF17FA5, 1)];
            _titleLab.text = @"访客数量";
    }
    if (_chartType == OrderStatis) {
        [self configContentBackgroudColor:RHColorHex(0x6aa0f8, 1) end:RHColorHex(0x5dccea, 1)];
            _titleLab.text = @"订单数量";
        
    }

    if (_chartType == ActiveOrderStatis) {
             [self configContentBackgroudColor:RHColorHex(0x92D390, 1) end:RHColorHex(0x9DCD4F, 1)];
            _titleLab.text = @"活动订单";
    }

    if (_chartType == OrderPriceStatis) {
             [self configContentBackgroudColor:RHColorHex(0xeec95f, 1) end:RHColorHex(0xf19066, 1)];
        _titleLab.text = @"近日收入";
    }

   

}

#pragma mark - 点击
- (IBAction)segementSelect:(id)sender {
    UISegmentedControl *segm = sender;
    if (_selecBlcok) {
        _selecBlcok(segm.selectedSegmentIndex);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
