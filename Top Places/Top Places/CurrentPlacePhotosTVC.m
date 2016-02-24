//
//  CurrentPlacePhotosTVC.m
//  Top Places
//
//  Created by iYww on 15/11/5.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "CurrentPlacePhotosTVC.h"
#import "URLFetch.h"
#import "FlickrFetcher.h"

@interface CurrentPlacePhotosTVC ()

@end

@implementation CurrentPlacePhotosTVC

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.refreshControl beginRefreshing];
    [self fetchPhotos];
}

#pragma mark - Fetch Photo List

- (IBAction)fetchPhotos {
    [self.refreshControl beginRefreshing];
    
    [URLFetch requestWithURL:self.photosURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [URLFetch parseURLToJson:location];
        NSArray *photos = [json valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            self.photos = photos;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    // unshift a photo to NSUserdefaults.recentViewedPhotos
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSInteger row = indexPath.row;
    NSDictionary *photo = self.photos[row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *oldViewedPhotos = [defaults valueForKey:@"recentViewedPhotos"];
    NSMutableArray *newViewedPhotos = [[NSMutableArray alloc] initWithArray:oldViewedPhotos];
    
    if([newViewedPhotos containsObject:photo]) {
        [newViewedPhotos removeObject:photo];
    }
    [newViewedPhotos insertObject:photo atIndex:0];
    
    [defaults setObject:newViewedPhotos forKey:@"recentViewedPhotos"];
}


@end
