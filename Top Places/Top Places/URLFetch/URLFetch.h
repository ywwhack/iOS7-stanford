//
//  URLFetch.h
//  Top Places
//
//  Created by iYww on 15/11/4.
//  Copyright © 2015年 zank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^completionHandler)(NSURL *location, NSURLResponse *response, NSError *error);

@interface URLFetch : NSObject

+ (void)requestWithURL:(NSURL *)url completionHandler:(completionHandler)completionHandler;
+ (NSDictionary *)parseURLToJson:(NSURL *)url;
+ (UIImage *)parseURLToImage:(NSURL *)url;

@end
