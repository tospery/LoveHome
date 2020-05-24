//
//  AdressPicker.m
//  Pikcer
//
//  Created by MRH-MAC on 15/1/8.
//  Copyright (c) 2015年 MRH-MAC. All rights reserved.
//

#import "AdressPicker.h"

@interface AdressPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic , strong) UIPickerView *picker;

@property (nonatomic , strong) UIView *contentView;

@property (strong, nonatomic) UIView *coverView;

@end

@implementation AdressPicker


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        

        
        //添加Cover
        CGRect rect = [UIScreen mainScreen].bounds;
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        
        _coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_coverView];
        self.hidden = YES;
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, [UIScreen mainScreen].bounds.size.width , 190)];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.layer.cornerRadius = 3;
    [self addSubview:_contentView];

    // 添加标题
    UILabel *lable        = [[UILabel alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 35)];
    lable.backgroundColor = [UIColor lightGrayColor];
    lable.font            = [UIFont systemFontOfSize:17];
    lable.textColor       = [UIColor blackColor];
    lable.textAlignment   = NSTextAlignmentCenter;
    lable.text            = @"地址选择";
    [_contentView addSubview:lable];

    
    // 数据初始
    [self initData];
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,35,[UIScreen mainScreen].bounds.size.width, _contentView.height - lable.height) ];
    
    _picker.showsSelectionIndicator = YES;
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.delegate = self;
    _picker.dataSource = self;
    
    [_contentView addSubview:_picker];
}


- (void)initData
{
    
    
     _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];

    _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
    
    self.state = [[_provinces objectAtIndex:0] objectForKey:@"state"];
    

    self.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
        
    _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
    if (_areas.count > 0)
    {
        self.district = [_areas objectAtIndex:0];
        
    }
    else
    {
            self.district = @"";
    }
        


}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 3;
 
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_provinces count];
            break;
        case 1:
            return [_cities count];
            break;
        case 2:

                return [_areas count];
                break;

        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

        switch (component) {
            case 0:
                return [[_provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [[_cities objectAtIndex:row] objectForKey:@"city"];
                break;
            case 2:
                if ([_areas count] > 0) {
                    return [_areas objectAtIndex:row];
                    break;
                }
            default:
                return  @"";
                break;
        }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

        switch (component) {
            case 0:
                _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.picker selectRow:0 inComponent:1 animated:YES];
                [self.picker reloadComponent:1];
                
                _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
                [self.picker selectRow:0 inComponent:2 animated:YES];
                [self.picker reloadComponent:2];
                
                self.state = [[_provinces objectAtIndex:row] objectForKey:@"state"];
                self.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
                if ([_areas count] > 0) {
                    self.district = [_areas objectAtIndex:0];
                } else{
                    self.district = @"";
                }
                break;
            case 1:
                _areas = [[_cities objectAtIndex:row] objectForKey:@"areas"];
                [self.picker selectRow:0 inComponent:2 animated:YES];
                [self.picker reloadComponent:2];
                
                self.city = [[_cities objectAtIndex:row] objectForKey:@"city"];
                if ([_areas count] > 0) {
                    self.district = [_areas objectAtIndex:0];
                } else{
                    self.district = @"";
                }
                break;
            case 2:
                if ([_areas count] > 0) {
                    self.district = [_areas objectAtIndex:row];
                } else{
                    self.district = @"";
                }
                break;
            default:
                break;
}
    
    if([self.delegate respondsToSelector:@selector(adressPickerDidChangeStatus:)]) {
        [self.delegate adressPickerDidChangeStatus:self];
    }
    
}

- (void)show
{
    
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    self.hidden = NO;
    
    _coverView.alpha = 0.0f;

    [UIView animateWithDuration:0.35 animations:^{
        self.coverView.alpha = 1.0f;
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,self.bounds.size.height - 190 ,self.contentView.bounds.size.width, 190) ;
    }];

}

- (void)endView
{
    __weak AdressPicker *myself = self;
    [UIView animateWithDuration:0.35 animations:^{
        myself.coverView.alpha = 0.0f;
        myself.contentView.frame = CGRectMake(myself.contentView.frame.origin.x,myself.bounds.size.height ,myself.contentView.bounds.size.width, 190) ;
        
    } completion:^(BOOL finished) {
        myself.hidden = YES;
    }];
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endView];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
