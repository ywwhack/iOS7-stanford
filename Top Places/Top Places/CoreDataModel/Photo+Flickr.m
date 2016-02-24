//
//  Photo+Flickr.m
//  Top Places
//
//  Created by iYww on 15/11/7.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Place+Flickr.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoInfo inManagedObjectContext:(NSManagedObjectContext *)context {
    Photo *photo = nil;
    
    NSString *unique = [photoInfo valueForKeyPath:FLICKR_PHOTO_ID];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] >=2 || error) {
        // handle error
    }else if([matches count]) {
        // photo already in database, just return it
        photo = [matches firstObject];
    }else {
        // photo not in database, create one, and return it
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = unique;
        photo.title = [photoInfo valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle = [photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoInfo format:FlickrPhotoFormatLarge] absoluteString];
        
        NSString *palceId = [photoInfo valueForKeyPath:FLICKR_PLACE_ID];
        photo.whereTook = [Place placeWithUnique:palceId inManagedObjectContext:context];
    }
    
    return photo;
}

+ (void)loadPhotosFromFlickrArray:(NSArray *)photos inManagedObjectContext:(NSManagedObjectContext *)context {
    for(NSDictionary *photoInfo in photos) {
        [self photoWithFlickrInfo:photoInfo inManagedObjectContext:context];
    }
}
@end
