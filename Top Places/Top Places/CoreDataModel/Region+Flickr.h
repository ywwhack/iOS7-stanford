//
//  Region+Flickr.h
//  Top Places
//
//  Created by iYww on 15/11/7.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "Region.h"

@interface Region (Flickr)

+ (Region *)regionWithUnique:(NSString *)unique withName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
