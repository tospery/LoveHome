//
//  LHNearbyMapViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/31.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHShopMapViewController.h"
#import "LHShop.h"
#import "LHStarView.h"
#import "LHShopDetailViewController.h"

#define NearbyMapAnnotationIdentifier   (@"NearbyMapAnnotationIdentifier")

@interface LHShopMapViewController ()
@property (nonatomic, strong) LHShop *shop;
@property (nonatomic, strong) NSArray *shops;
@property (nonatomic, strong) BMKLocationService *locateService;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UIButton *logoButton;
@property (nonatomic, weak) IBOutlet LHStarView *starView;
@property (nonatomic, weak) IBOutlet BMKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIView *detailView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation LHShopMapViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
    [self initDB];
    [self initNet];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mapView viewWillAppear];
    self.locateService.delegate = self;
    self.mapView.delegate = self;
    [self.locateService startUserLocationService];
    //self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.mapView viewWillDisappear];
    self.locateService.delegate = nil;
    self.mapView.delegate = nil;
    [self.locateService stopUserLocationService];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    [self.locateService startUserLocationService];
    //    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    if (_isSingle && self.shops.count == 1) {
        [self.mapView selectAnnotation:self.shops[0] animated:YES];
    }
}

- (void)dealloc {
    self.locateService = nil;
    self.mapView = nil;
}

#pragma mark - Accessor methods
- (BMKLocationService *)locateService {
    if (!_locateService) {
        _locateService = [[BMKLocationService alloc] init];
    }
    return _locateService;
}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
}

- (void)initView {
    self.navigationItem.title = @"店铺列表";
    self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    
    self.starView.level = 0;
    self.starView.enabled = NO;
    [self.starView loadData];
    
    self.mapView.delegate = self;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.shops];
    [self.mapView showAnnotations:self.shops animated:NO];
    
    //self.mapView.centerCoordinate = CLLocationCoordinate2DMake(gLH.latitude, gLH.longitude);
    self.mapView.zoomLevel = 17;
    self.mapView.isSelectedAnnotationViewFront = YES;
    self.mapView.showsUserLocation = YES;
    
    if (!_isSingle) {
        self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    }
}

- (void)initDB {
}

- (void)initNet {
}

#pragma mark assist
- (void)configDetail {
    if (!self.shop) {
        return;
    }
    
    [self.logoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.shop.url] forState:UIControlStateNormal placeholderImage:kImagePHShopLogo];
    self.nameLabel.text = self.shop.title;
    self.addressLabel.text = self.shop.address;
    self.starView.level = self.shop.level;
    [self.starView loadData];
}

#pragma mark - Public methods
- (instancetype)initWithShops:(NSArray *)shops {
    if (self = [self init]) {
        _shops = shops;
    }
    return self;
}

#pragma mark - Action methods
- (void)leftBarItemPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)detailButtonPressed:(id)sender {
    //    if (self.shop.distance >= 3000) {
    //        JXToast(@"怪我咯！超过服务范围，求反馈~");
    //        return;
    //    }
    
    if (self.shop.freeze == 2) {
        JXToast(@"这家店不乖，被关小黑屋了~");
    }else if (self.shop.freeze == 4) {
        JXToast(@"主人，店主回高老庄去了，请移步别家~");
    }else if (self.shop.freeze == 5) {
        JXToast(@"主人，店家去月球度假了，请移步别家~");
    }else {
        LHShopDetailViewController *vc = [[LHShopDetailViewController alloc] initWithShop:self.shop];
        vc.from = LHEntryFromMap;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Delegate methods
#pragma mark BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation {
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:NearbyMapAnnotationIdentifier];
    if (!annotationView) {
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NearbyMapAnnotationIdentifier];
    }
    annotationView.image = [UIImage imageNamed:@"ic_map_shop"];
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.draggable = NO;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    if ([[view.annotation title] isEqualToString:@"我的位置"]) {
        [mapView bringSubviewToFront:view];
        [mapView setNeedsDisplay];
        return;
    }
    
    for (LHShop *shop in self.shops) {
        if ([[view.annotation title] isEqualToString:shop.title]) {
            self.shop = shop;
            break;
        }
    }
    [self configDetail];
    
    
    if (JXiOSVersionGreaterThanOrEqual(8.0)) {
        if (0 != self.bottomConstraint.constant) {
            self.bottomConstraint.constant = 0;
            [self.view setNeedsUpdateConstraints];
            [self.view updateConstraintsIfNeeded];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:0 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [mapView bringSubviewToFront:view];
                [mapView setNeedsDisplay];
            }];
        }else {
            [mapView bringSubviewToFront:view];
            [mapView setNeedsDisplay];
        }
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect frame = self.detailView.frame;
            if (frame.origin.y == kJXScreenHeight - 64) {
                CGRect changed = CGRectMake(0, kJXScreenHeight - 64 - 100, frame.size.width, frame.size.height);
                [UIView animateWithDuration:0.3 animations:^{
                    self.detailView.frame = changed;
                } completion:^(BOOL finished) {
                    [mapView bringSubviewToFront:view];
                    [mapView setNeedsDisplay];
                }];
            }else {
                [mapView bringSubviewToFront:view];
                [mapView setNeedsDisplay];
            }
        });
    }
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
}

#pragma mark BMKLocationServiceDelegate
- (void)willStartLocatingUser {
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    [self.mapView updateLocationData:userLocation];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [self.mapView updateLocationData:userLocation];
}

- (void)didStopLocatingUser {
}

- (void)didFailToLocateUserWithError:(NSError *)error {
}

@end
