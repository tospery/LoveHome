//
//  LHHomeViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHBaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LHHomeViewController : LHBaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@end
