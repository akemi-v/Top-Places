//
//  FlickrFetcherModification.h
//  Top Places
//
//  Created by Apple on 8/28/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "FlickrFetcher.h"

@interface FlickrFetcherModification : FlickrFetcher

+ (void)downloadTopPlaces:(void (^)(NSArray *places, NSError *error))completionHandler;
+ (void)downloadPhotosForPlace:(NSDictionary *)place numOfResults:(NSUInteger)results onCompletion:(void (^)(NSArray *photos, NSError *error))completionHandler;

+ (NSString *)countryOfPlace:(NSDictionary *)place;
+ (NSString *)titleOfPlace:(NSDictionary *)place;
+ (NSString *)subtitleOfPlace:(NSDictionary *)place;
+ (NSArray *)sortPlaces:(NSArray *)places;
+ (NSDictionary *)placesByCountries:(NSArray *)places;
+ (NSArray *)countries:(NSDictionary *)placesByCountries;

@end
