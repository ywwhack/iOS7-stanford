//
//  PhotoListTVC.m
//  Top Places
//
//  Created by iYww on 15/11/4.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "PhotoListTVC.h"
#import "FlickrFetcher.h"
#import "URLFetch.h"
#import "ImageVC.h"

@interface PhotoListTVC ()

@end

@implementation PhotoListTVC

#pragma mark - Properties

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo List" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    
    NSDictionary *photo = self.photos[row];
    NSString *title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSString *description = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if([title isEqualToString:@""]) {
        title = @"Unknown";
    }
    if([description isEqualToString:@""]) {
        description = title;
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSInteger row = indexPath.row;
    NSDictionary *photo = self.photos[row];
    
    ImageVC *ivc = [segue destinationViewController];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
}


@end
