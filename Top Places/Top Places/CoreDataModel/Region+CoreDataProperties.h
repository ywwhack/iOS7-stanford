//
//  Region+CoreDataProperties.h
//  Top Places
//
//  Created by iYww on 15/11/7.
//  Copyright © 2015年 zank. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Region.h"

NS_ASSUME_NONNULL_BEGIN

@interface Region (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *unique;
@property (nullable, nonatomic, retain) NSSet<Place *> *palces;

@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addPalcesObject:(Place *)value;
- (void)removePalcesObject:(Place *)value;
- (void)addPalces:(NSSet<Place *> *)values;
- (void)removePalces:(NSSet<Place *> *)values;

@end

NS_ASSUME_NONNULL_END
