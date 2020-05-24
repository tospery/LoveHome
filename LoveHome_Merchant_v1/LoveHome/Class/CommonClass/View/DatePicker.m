//
//  DatePicker.m
//  爱为家
//
//  Created by MRH-MAC on 14-10-6.
//  Copyright (c) 2014年 MRH-MAC. All rights reserved.
//

#import "DatePicker.h"

@interface DatePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>
{

    UILabel *_myView;


}
@property (nonatomic ,strong)  UIView *contentView;
@property (nonatomic ,strong)   UILabel *myView;
@property (nonatomic,strong)    NSString *content1;
@property (nonatomic,strong)    NSString *content2;
@property (nonatomic ,retain)   NSArray *arry;
@property (nonatomic ,retain)   NSArray *arry2;
@property (nonatomic ,retain)   NSArray *titles;
@property (nonatomic ,assign)   NSInteger section;
@property (strong, nonatomic) UIPickerView *datePicker;
@property (strong, nonatomic) UIView *coverView;

@end

@implementation DatePicker

- (id)initWithtitle:(NSArray *)titles;
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.titles = titles;
        self.isShowTitle = YES;
        [self setConfigSubView];
        
    }
    return self;
}


- (id)initWithtitle:(NSArray *)titles isShowTitle:(BOOL)isShow
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.titles = titles;
        self.isShowTitle = isShow;
        [self setConfigSubView];
        
    }
    return self;
}

- (void)setConfigSubView
{
        // 配置picker属性
        self.hidden = YES;
        self.arry = [[NSArray alloc] init];
        self.arry2 = [[NSArray alloc] init];
        self.section = 0;
        
        //添加Cover
        CGRect rect = [UIScreen mainScreen].bounds;
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        
        _coverView.backgroundColor = COLOR_CUSTOM(0, 0, 0, 0.5);
        [self addSubview:_coverView];
        [self initView];
    

}

- (void)setContentData:(NSArray *)data andSconde:(NSArray *)SecondeData
{

    _arry  = [NSArray arrayWithArray:data];
    _arry2 = [NSArray arrayWithArray:SecondeData];
    [_datePicker reloadAllComponents];

}



- (void)initView
{

    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, [UIScreen mainScreen].bounds.size.width , 190)];
    _contentView.layer.cornerRadius = 3;
    [self addSubview:_contentView];
    
    


    [self initTitleView];
    

    
    self.datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,35,[UIScreen mainScreen].bounds.size.width, _contentView.height) ];

    _datePicker.showsSelectionIndicator = YES;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.delegate = self;
    _datePicker.dataSource = self;

    [_contentView addSubview:_datePicker];
    
}

- (void)initTitleView
{
    
    if (!_isShowTitle) {
        
        _section = 2;
        UIButton *firstTitle = [[UIButton alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width / 2 , 35)];
        UIButton *seconTitle = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 ,0, [UIScreen mainScreen].bounds.size.width / 2, 35)];
        
        firstTitle.backgroundColor = COLOR_CUSTOM(241, 241, 241, 1);
        seconTitle.backgroundColor = COLOR_CUSTOM(241, 241, 241, 1);
        
        [firstTitle setTitle:@"关闭" forState:UIControlStateNormal];
        [seconTitle setTitle:@"确定" forState:UIControlStateNormal];
        
        [firstTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [seconTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        firstTitle.backgroundColor = [UIColor lightGrayColor];
        firstTitle.titleLabel.font = [UIFont systemFontOfSize:17];
        seconTitle.titleLabel.font = [UIFont systemFontOfSize:17];
        firstTitle.titleLabel.textAlignment = NSTextAlignmentLeft;
        seconTitle.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [firstTitle addTarget:self action:@selector(CloseButton) forControlEvents:UIControlEventTouchUpInside];
        
        [seconTitle addTarget:self action:@selector(surceButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:firstTitle];
        [_contentView addSubview:seconTitle];

        
        
        return;
    }
    
    
    if ([self.titles count] == 1) {
        _section =1;
        
        // 添加标题
        UILabel *lable        = [[UILabel alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 35)];
        lable.backgroundColor = COLOR_CUSTOM(3, 156, 228, 1);
        lable.font            = [UIFont systemFontOfSize:17];
        lable.textColor       = [UIColor whiteColor];
        
        lable.textAlignment   = NSTextAlignmentCenter;
        lable.text            = _titles[0];
        [_contentView addSubview:lable];
        
        
    }else if ([self.titles count] == 2)
    {
        _section = 2;
        
        UILabel *firstTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width / 2 , 35)];
        UILabel *seconTitle = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 ,0, [UIScreen mainScreen].bounds.size.width / 2, 35)];
        
        firstTitle.backgroundColor = COLOR_CUSTOM(241, 241, 241, 1);
        seconTitle.backgroundColor = COLOR_CUSTOM(241, 241, 241, 1);
        
        firstTitle.textColor = [UIColor blackColor];
        seconTitle.textColor = [UIColor blackColor];
        firstTitle.text = _titles[0];
        seconTitle.text = _titles[1];
        
        firstTitle.font = [UIFont systemFontOfSize:17];
        seconTitle.font = [UIFont systemFontOfSize:17];
        firstTitle.textAlignment = NSTextAlignmentLeft;
        seconTitle.textAlignment = NSTextAlignmentRight;
        
        [_contentView addSubview:firstTitle];
        [_contentView addSubview:seconTitle];
        
    }
    
}



#pragma mark -PickeViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _section;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_section == 1) {
        return _arry.count;
    
    }else
    {
        if (component == 0) {
            return _arry.count;
        }else
        {
            return _arry2.count;
        }
    }
    
}


#pragma  mark 返回Picker的content 数量

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row  forComponent:(NSInteger)component {

    
    if (_section == 1)
    {
       
        return [_arry objectAtIndex:row];

      
    }
    else
    {
        if (component == 0) {
        
            return  [_arry objectAtIndex:row];
            
        }else
        {
            return  [_arry2 objectAtIndex:row];
        }
        
    }

}


#pragma mark 返回列数
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (_section == 1) {
        NSString *string;
        string = [NSString stringWithFormat:@"%@",_arry[row]];
        if (_block) {
        _block(string,nil);
            }

        
    }
    //列数
    else
    {
    
        if (0 == component) {
            if (_content2 == nil) {
                self.content2 = [_arry2 lastObject];
            }
            self.content1 = _arry[row];
            NSString *string = [NSString stringWithFormat:@"%@-%@",_content1,_content2];
            if (_block) {
                _block(string,nil);
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(changeDelegateString:)]) {
                
                [_delegate changeDelegateString:string];
            }
            
//            if (_choosePickerBlock)
//            {
//                _choosePickerBlock(_content1,_content2);
//            }
            
        }else
        {
            if (_content1 == nil) {
                self.content1 = [_arry firstObject];
            }
            self.content2 = _arry2[row];
            NSString *string = [NSString stringWithFormat:@"%@-%@",_content1,_content2];
            if (_block) {
                _block(string,nil);
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(changeDelegateString:)]) {
                
                [_delegate changeDelegateString:string];
            }

//            
//            if (_choosePickerBlock)
//            {
//                _choosePickerBlock(_content1,_content2);
//            }
        }
    }
}


- (void)coverStarAnimation
{
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self])
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    self.hidden = NO;
    
    _coverView.alpha = 0.0f;
    __weak DatePicker *myself = self;
    [UIView animateWithDuration:0.35 animations:^{
        myself.coverView.alpha = 1.0f;
        myself.contentView.frame = CGRectMake(myself.contentView.frame.origin.x,myself.bounds.size.height - 190 ,myself.contentView.bounds.size.width, 190) ;
    }];
    
}


- (void)coverEndAnimation
{

    __weak DatePicker *myself = self;
    [UIView animateWithDuration:0.35 animations:^{
        myself.coverView.alpha = 0.0f;
        myself.contentView.frame = CGRectMake(myself.contentView.frame.origin.x,myself.bounds.size.height ,myself.contentView.bounds.size.width, 190) ;
        
    } completion:^(BOOL finished) {
         myself.hidden = YES;
    }];

}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self coverEndAnimation];
    
    if (_delegate && [_delegate respondsToSelector:@selector(datePcickerCancel:)]) {
        [_delegate datePcickerCancel:self];
    }

}


- (void)scrollRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{

    [self.datePicker  selectRow:row inComponent:component animated:animated];
}


- (void)CloseButton
{
    [self coverEndAnimation];
}

- (void)surceButton
{
    
    NSString *star = [_content1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *end = [_content2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSInteger aa = [star floatValue];
    NSInteger bb  = [end floatValue];
    
    if (bb < aa) {
        JXToast(@"结束日期不能小于开始日期");
        return;
    }
    
    
    
    [self coverEndAnimation];
    if (_choosePickerBlock) {
        _choosePickerBlock(_content1,_content2);
    }
}

@end
