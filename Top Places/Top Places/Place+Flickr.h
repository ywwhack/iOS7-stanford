//
//  Place+Flickr.h
//  Top Places
//
//  Created by iYww on 15/11/7.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "Place.h"

@interface Place (Flickr)

+ (Place *)placeWithUnique:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context;

@end
