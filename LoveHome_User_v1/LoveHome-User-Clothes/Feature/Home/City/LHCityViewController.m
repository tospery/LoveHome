//
//  LHCityViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/10.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCityViewController.h"

@interface LHCityViewController ()
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LHCityViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
    [self initDB];
    [self initNet];
}

#pragma mark - Private methods
- (void)initVar {
    self.cities = @[@"成都"];
}

- (void)initView {
    self.navigationItem.title = @"城市";
    self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kJXIdentifierCellSystem];
}

- (void)initDB {
}

- (void)initNet {
}

#pragma mark - Action methods
- (void)leftBarItemPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kJXStandardCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJXIdentifierCellSystem];
    cell.textLabel.text = self.cities[indexPath.row];
    
    if (0 == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}
@end
