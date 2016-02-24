//
//  Photo+CoreDataProperties.h
//  Top Places
//
//  Created by iYww on 15/11/9.
//  Copyright © 2015年 zank. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo.h"

@class Place;

NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *subtitle;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *unique;
@property (nullable, nonatomic, retain) Place *whereTook;

@end

NS_ASSUME_NONNULL_END
