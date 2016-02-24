//
//  Region+Flickr.m
//  Top Places
//
//  Created by iYww on 15/11/7.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "Region+Flickr.h"

@implementation Region (Flickr)

+ (Region *)regionWithUnique:(NSString *)unique withName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    Region *region = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSArray *matches = [context executeFetchRequest:request error:NULL];
    
    if([matches count]) {
        return [matches firstObject];
    }else {
        region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
        region.unique = unique;
        region.name = name;
    }

    return region;
}

@end
