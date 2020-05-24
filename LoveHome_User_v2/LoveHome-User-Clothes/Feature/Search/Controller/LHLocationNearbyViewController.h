//
//  LHLocationNearbyViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/21.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHLocationNearbyViewController : LHBaseViewController <UITableViewDataSource, UITableViewDelegate, BMKGeoCodeSearchDelegate>
@property(assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
