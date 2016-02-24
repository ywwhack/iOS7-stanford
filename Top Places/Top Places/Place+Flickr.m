//
//  Place+Flickr.m
//  Top Places
//
//  Created by iYww on 15/11/7.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "Place+Flickr.h"
#import "URLFetch.h"
#import "Region+Flickr.h"
#import "FlickrFetcher.h"

@implementation Place (Flickr)

+ (Place *)placeWithUnique:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context {
    Place *place = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] >=2 || error) {
    
    }else if([matches count] && matches[0] != nil) {
        return [matches firstObject];
    }else {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        NSURL *url = [FlickrFetcher URLforInformationAboutPlace:unique];
        [URLFetch requestWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSDictionary *placeInfo = [URLFetch parseURLToJson:location];
            NSString *regionName = [placeInfo valueForKeyPath:FLICKR_REGION_NAME];
            NSString *regionUnique = [placeInfo valueForKeyPath:FLICKR_REGION_ID];
            NSLog(@"%@", placeInfo);
            place.unique = unique;
            place.name = [placeInfo valueForKeyPath:FLICKR_PLACE_WOE_NAME];
            place.region = [Region regionWithUnique:regionUnique withName:regionName inManagedObjectContext:context];
        }];
    }
    
    return place;
}

@end
