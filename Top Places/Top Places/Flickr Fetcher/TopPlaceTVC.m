//
//  TopPlaceTVC.m
//  Top Places
//
//  Created by iYww on 15/11/3.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "TopPlaceTVC.h"
#import "FlickrFetcher.h"
#import "CurrentPlacePhotosTVC.h"
#import "URLFetch.h"
#import "Photo+Flickr.h"
#import "Place.h"

@interface TopPlaceTVC ()

@property (strong, nonatomic) NSMutableArray *countries;
@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSArray *photos;

@end

@implementation TopPlaceTVC

#define DB_NAME @"Flickr"

#pragma mark - Properties

- (NSMutableDictionary *)countrySections {
    if(!_countrySections) {
        _countrySections = [[NSMutableDictionary alloc] init];
    }
    return _countrySections;
}

- (NSMutableArray *)countries {
    if(!_countries) {
        _countries = [[NSMutableArray alloc] init];
    }
    return _countries;
}

- (NSMutableArray *)cities {
    if(!_cities) {
        _cities = [[NSMutableArray alloc] init];
    }
    return _cities;
}

- (UIManagedDocument *)document {
    if(!_document) {
        _document = [self documentForDb];
    }
    return _document;
}

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startFetchTopPlace];
    
    [self startFetchTopRegions];
}

#pragma mark - Fetch Top Regions

- (IBAction)startFetchTopRegions {
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    [URLFetch requestWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        self.photos = [[URLFetch parseURLToJson:location] valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *dbPath = [self dbPath:DB_NAME];
        
        if([fileManager fileExistsAtPath:dbPath]) {
            [self.document openWithCompletionHandler:^(BOOL success) {
                [self documentIsReady];
            }];
            NSLog(@"open");
        }else {
            [self.document saveToURL:[NSURL fileURLWithPath:dbPath]
               forSaveOperation:UIDocumentSaveForCreating
              completionHandler:^(BOOL success) {
                  [self documentIsReady];
            }];
            NSLog(@"create");
        }
    }];
}

- (void)documentIsReady {
    if(self.document.documentState == UIDocumentStateNormal) {
        NSManagedObjectContext *context = self.document.managedObjectContext;
        [context performBlock:^ {
            [Photo loadPhotosFromFlickrArray:self.photos inManagedObjectContext:self.document.managedObjectContext];
    
            for(NSDictionary *photoInfo in self.photos) {
                Photo *photo = [Photo photoWithFlickrInfo:photoInfo inManagedObjectContext:self.document.managedObjectContext];
                NSLog(@"%@", [photo.whereTook committedValuesForKeys:nil]);
            }
        }];
    }else {
        NSLog(@"document error: %ld", self.document.documentState);
    }
}

- (UIManagedDocument *)documentForDb {
    return [[UIManagedDocument alloc] initWithFileURL:[NSURL fileURLWithPath:[self dbPath:DB_NAME]]];
}

- (NSString *)dbPath:(NSString *)dbName {
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentsDir stringByAppendingPathComponent:dbName];
}

#pragma mark - Fetch Top Place

- (IBAction)startFetchTopPlace {
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforTopPlaces];

    dispatch_queue_t fetchQ = dispatch_queue_create("fetch", NULL);
    dispatch_async(fetchQ, ^ {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData *jsonData = [NSData dataWithContentsOfURL:location];
            NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
            NSArray *placeArr = [jsonResult valueForKeyPath:FLICKR_RESULTS_PLACES];
        
            NSMutableDictionary *countries = [[NSMutableDictionary alloc] init];
            for(NSDictionary *place in placeArr) {
                NSString *fullName = [place objectForKey:FLICKR_PLACE_NAME];
                NSArray *fullNameArr = [fullName componentsSeparatedByString:@", "];
                NSString *city = [fullNameArr firstObject];
                NSString *country = [fullNameArr lastObject];
                if([fullNameArr count] == 3) {
                    city = [city stringByAppendingString:[NSString stringWithFormat:@", %@",fullNameArr[1]]];
                }
                
                NSMutableArray *cities = [countries objectForKey:country] ? [countries objectForKey:country] : [[NSMutableArray alloc] init];
                [cities addObject:@{@"name":city, @"id":[place objectForKey:FLICKR_PHOTO_PLACE_ID]}];
                
                [countries setObject:cities forKey:country];
            }
            
            [self clearPreviousData];
            for(NSString *country in countries) {
                NSArray *cities = [countries objectForKey:country];
                [self.countries addObject:country];
                [self.countrySections setObject:[self sortWithCity:cities] forKey:country];
            }
            
            self.countries = [NSMutableArray arrayWithArray:[self sortWithCountry:self.countries]];
            
            for(NSString *country in self.countries) {
                [self.cities addObject:[self.countrySections valueForKey:country]];
            }

            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            });
        }];
        
        [downloadTask resume];
    });
}

- (NSArray *)sortWithCountry:(NSArray *)array {
    return [array sortedArrayUsingComparator:^(NSString *str1, NSString *str2) {
        return [str1 localizedCompare:str2];
    }];
}

- (NSArray *)sortWithCity:(NSArray *)array {
    return [array sortedArrayUsingComparator:^(NSDictionary *obj1, NSDictionary *obj2) {
        return [[obj1 objectForKey:@"name"] localizedCompare:[obj2 objectForKey:@"name"]];
    }];
}

- (void)clearPreviousData {
    [self.countries removeAllObjects];
    [self.cities removeAllObjects];
    [self.countrySections removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.countrySections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cities[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.countries ? self.countries[section] : @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Top Place" forIndexPath:indexPath];

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *cityAndProvince = [[self.cities[section][row] objectForKey:@"name"] componentsSeparatedByString:@", "];
    cell.textLabel.text = cityAndProvince[0];
    if([cityAndProvince count] == 2) {
        cell.detailTextLabel.text = cityAndProvince[1];
    }else {
        cell.detailTextLabel.text = cityAndProvince[0];
    }
    
    return cell;
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSString *placeId = [self.cities[section][row] objectForKey:@"id"];
    NSURL *photosURL = [FlickrFetcher URLforPhotosInPlace:placeId maxResults:50];
    
    CurrentPlacePhotosTVC *tvc = [segue destinationViewController];
    tvc.title = self.countries[section];
    tvc.photosURL = photosURL;
}


@end
