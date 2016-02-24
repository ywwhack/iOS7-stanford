//
//  RecentPhotosTVC.m
//  Top Places
//
//  Created by iYww on 15/11/5.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "RecentPhotosTVC.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.photos = [defaults valueForKey:@"recentViewedPhotos"];
}

#pragma mark - Table View Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self.photos count] > 20 ? 20 : [self.photos count]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
