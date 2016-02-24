//
//  Photo+Flickr.h
//  Top Places
//
//  Created by iYww on 15/11/7.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoInfo inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)loadPhotosFromFlickrArray:(NSArray *)photos inManagedObjectContext:(NSManagedObjectContext *)context;

@end
