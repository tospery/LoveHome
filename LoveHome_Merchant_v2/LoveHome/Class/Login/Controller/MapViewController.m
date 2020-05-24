//
//  MaoViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/7.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "MapViewController.h"
#import "AlphaLableView.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>
@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic,strong) BMKMapView* mapView;
@property (nonatomic,strong) BMKLocationService *locationServer;
@property (nonatomic ,strong) AlphaLableView *titleViw;
@property (nonatomic,strong) BMKGeoCodeSearch* geocodesearch;
@end

@implementation MapViewController


- (void)viewWillAppear:(BOOL)animated
{
  [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate =self;
}


- (void)viewDidDisappear:(BOOL)animated
{
   [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geocodesearch.delegate =nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址详情";
    
    // 反编码
	_geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.zoomLevel = 18;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.view  addSubview:self.mapView];
    
    //3.添加标记
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.center = CGPointMake(self.view.bounds.size.width /2, self.view.bounds.size.height / 2);
    imageView.bounds = CGRectMake(0, 0, 30, 30);
    imageView.image = [UIImage imageNamed:@"icon_locateAddressDown"];
    [self.view addSubview:imageView];
    [self locationManager];
    
    
    _titleViw = [[AlphaLableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _titleViw.center =   CGPointMake(self.view.bounds.size.width / 2 , self.view.bounds.size.height / 2 - 30);
    _titleViw.layer.cornerRadius = 4;
    _titleViw.hidden = YES;
    _titleViw.bounds = CGRectMake(0, 0, 100, 40);
    [self.view addSubview:_titleViw];
    
    [_titleViw setNeedsDisplay];

}

- (void)locationManager
{
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:10.f];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:500.f];
    
    //初始化BMKLocationService
    _locationServer = [[BMKLocationService alloc]init];
    _locationServer.delegate = self;
    //启动LocationService
    [_locationServer startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    self.mapView.showsUserLocation = NO;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    return nil;
}
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    _titleViw.hidden = YES;
    _titleViw.ContentText = @"";
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"%lf,-----%lf", mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);   ;
    
    _titleViw.hidden = NO;
    [_titleViw.loadingView startAnimating];
    //获取当前中心点位置
    CLLocationCoordinate2D center = mapView.region.center;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = center;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {

    }
    else
    {

    }

}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
////    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
////    [_mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = [NSString stringWithFormat:@"%@%@",result.addressDetail.streetName,result.addressDetail.streetNumber];

        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@%@",result.addressDetail.streetName,result.addressDetail.streetNumber];
        [self showLable:showmeg];
        if (_adressBlcok) {
            if (JudgeContainerCountIsNull(showmeg)) {
                showmeg =@"";
            }
            _adressBlcok(showmeg,_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
        }
        
    }
    else
    {
        [_titleViw.loadingView stopAnimating];
        _titleViw.hidden = YES;
    }
}

- (void)showLable:(NSString *)string
{
    CGSize size = CGSizeMake(SCREEN_WIDTH - 51, MAXFLOAT);
    
    NSDictionary * attributes = @{NSFontAttributeName :[UIFont systemFontOfSize:14]};
    CGSize stringSize =[string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    _titleViw.bounds = CGRectMake(0, 0, stringSize.width + 10, stringSize.height + 20);
    _titleViw.ContentText = string;
    _titleViw.hidden = NO;
    [_titleViw.loadingView stopAnimating];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
