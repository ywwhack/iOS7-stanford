//
//  URLFetch.m
//  Top Places
//
//  Created by iYww on 15/11/4.
//  Copyright © 2015年 zank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLFetch.h"

@implementation URLFetch

+ (void)requestWithURL:(NSURL *)url completionHandler:(completionHandler)completionHandler {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:completionHandler];
    
    [task resume];
}

+ (NSDictionary *)parseURLToJson:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return json;
}

+ (UIImage *)parseURLToImage:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

@end
