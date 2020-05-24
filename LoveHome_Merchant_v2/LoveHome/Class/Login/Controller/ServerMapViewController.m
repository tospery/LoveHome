//
//  ServerMaoViewController.m
//  LoveHome
//
//  Created by MRH on 15/12/9.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#warning 这个才是正常的!

#import "ServerMapViewController.h"
#import "AlphaLableView.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>

@interface ServerMapViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate, BMKPoiSearchDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property (weak, nonatomic) IBOutlet UIView *mapContentView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSArray *searchDataSource;
@property (nonatomic,strong) NSArray *listDataSource;

@property (nonatomic,strong) BMKMapView* mapView;
@property (nonatomic,strong) BMKLocationService *locationServer;
@property (nonatomic ,strong) AlphaLableView *titleViw;
@property (nonatomic,strong) BMKGeoCodeSearch* geocodesearch;
@property (nonatomic,strong) CAShapeLayer *coverLayer;

//搜索
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) BMKPoiSearch *poisearch;
@end

@implementation ServerMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate =self;
    
    _poisearch.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_coverLayer) {
        [self drawCoverMask];
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpDB];
    [self setUpUI];
    [self SetUpNet];
    [self setupVar];
    
    
}

//不使用时将delegate设置为 nil,否则会影响内存释放
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    _mapView.delegate = nil;
    _geocodesearch.delegate =nil;
    
    _poisearch.delegate = nil;
}

#pragma mark - PraviteFuction

- (void)setUpDB
{
    self.title = @"地址详情";
    _searchDataSource = [[NSArray alloc] init];
    _listDataSource   = [[NSArray alloc] init];
    _searchController.delegate = self;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
}
- (void)setupVar {
   
    _results = [NSMutableArray array];
    _poisearch = [[BMKPoiSearch alloc] init];
}


- (void)setUpUI
{
    // 反编码
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_WIDTH * 0.87)];
    self.mapView.zoomLevel = 18;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [_mapContentView  addSubview:self.mapView];
    
    //3.添加标记
    [self locationManager];
    _titleViw = [[AlphaLableView alloc] init];
    _titleViw.center =   CGPointMake(_mapView.center.x ,_mapView.center.y  - 30);
    _titleViw.layer.cornerRadius = 4;
    _titleViw.hidden = YES;
    _titleViw.bounds = CGRectMake(0, 0, 100, 40);
    
    _myTableView.tableFooterView = [UIView new];


}

- (void)SetUpNet
{
    
}
//地图覆盖物

- (void)drawCoverMask {
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.87)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.userInteractionEnabled = NO;
    [_mapContentView addSubview:tempView];
    
    _coverLayer = [CAShapeLayer layer];
    _coverLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _coverLayer.fillColor = RHColorHex(0xFF4474, 0.5).CGColor;
    UIBezierPath *beizier = [UIBezierPath bezierPath];
    CGFloat radius = (tempView.width - 100) / 2;
    [beizier addArcWithCenter:tempView.center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [beizier closePath];
    _coverLayer.path = beizier.CGPath;
    [tempView.layer addSublayer:_coverLayer];
    

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.center = _mapView.center;
    imageView.bounds = CGRectMake(0, 0, 30, 30);
    imageView.image = [UIImage imageNamed:@"icon_locateAddressDown"];
    [_mapContentView addSubview:imageView];

    [_mapContentView addSubview:_titleViw];
    [_titleViw setNeedsDisplay];

}

//- (CGFloat)getCuuretnRadius {

//    CGFloat rauit = 1;
//    if ([_rangeValue isEqualToString:@"3KM"]) {
//        
//    }
//    if ([_rangeValue isEqualToString:@"5KM"]) {
//        
//    }
//    if ([_rangeValue isEqualToString:@"10KM"]) {
//        
//    }
//}

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
     //根据地理坐标获取地址信息
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = [NSString stringWithFormat:@"%@%@",result.addressDetail.streetName,result.addressDetail.streetNumber];
        
        _listDataSource = result.poiList;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@%@",result.addressDetail.streetName,result.addressDetail.streetNumber];
        [self showLable:showmeg];
        [_myTableView reloadData];
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
//覆盖物区域显示文字label
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
#pragma mark TableViewDlegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchController.searchResultsTableView) {
        return _results.count;

    }
    
    return _listDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == _searchController.searchResultsTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }

       // cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        BMKPoiInfo *info = _results[indexPath.row];
        cell.textLabel.text = info.name;
        cell.detailTextLabel.text = info.address;
        NSLog(@"搜索info.name = %@ , 搜索info.address = %@", info.name, info.address);
        NSLog(@"呵呵%@",_searchController.searchResultsTableView);
        return cell;
    }
    else if (tableView == self.myTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"systemCell"];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
            view.backgroundColor = [UIColor clearColor];
            UIImageView *slectView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 20, 20, 20)];
            slectView.image = [UIImage imageNamed:@"autoLoginCheckButton"];
            [view addSubview:slectView];
            cell.selectedBackgroundView =view;
        }
    
        BMKPoiInfo *info = _listDataSource[indexPath.row];
        cell.textLabel.text = info.name;
        cell.detailTextLabel.text = info.address;
        NSLog(@"info.name = %@ , info.address = %@", info.name, info.address);
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _myTableView) {
          BMKPoiInfo *info = _listDataSource[indexPath.row];
        NSString *showmeg;
        if (_adressBlcok) {
            if (JudgeContainerCountIsNull(info.name)) {
                showmeg =@"";
            }
            showmeg = info.address;
            [self showLable:showmeg];
            _adressBlcok(showmeg,_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
        }

    }
    else
    {
        BMKPoiInfo *info = _results[indexPath.row];
        NSString *showmeg;
        if (_adressBlcok) {
            if (JudgeContainerCountIsNull(info.name)) {
                showmeg =@"";
            }
            
            showmeg = info.address;
            [self showLable:showmeg];
            _adressBlcok(showmeg,_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
        }
        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"%@",_mySearchBar);
//        [_searchController.searchBar resignFirstResponder];
//        [_searchController setActive:NO animated:YES];
//        [self.view endEditing:YES];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
   
    NSLog(@"开始输入");
    
   
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
     self.mySearchBar = searchBar;
    NSLog(@"编辑结束");
    if (self.mySearchBar.text.length >= 1) {
        BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
        citySearchOption.pageIndex = 0;
        citySearchOption.pageCapacity = 20;
        citySearchOption.city= @"成都";
        citySearchOption.keyword = searchBar.text;
        BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
        if(flag) {
            NSLog(@"城市内检索发送成功");
        }else {
            NSLog(@"城市内检索发送失败");
        }
    }else {
        [_results removeAllObjects];
        [_myTableView reloadData];
    }

    
}
#pragma mark BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        [_results removeAllObjects];
        [_results addObjectsFromArray:poiResult.poiInfoList];
        [_searchController.searchResultsTableView reloadData];
    }
}

//实现Delegate处理回调结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    
}

#pragma mark - SearchDelegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
