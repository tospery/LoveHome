//
//  JXTableViewController.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXViewController.h"

@interface JXTableViewController : JXViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/// The table view for tableView controller.
@property (nonatomic, weak, readonly) UISearchBar *searchBar;
@property (nonatomic, weak, readonly) UITableView *tableView;
//@property (nonatomic, assign, readonly) UIEdgeInsets contentInset;

- (void)reloadData;
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end
