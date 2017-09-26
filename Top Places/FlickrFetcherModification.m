//
//  FlickrFetcherModification.m
//  Top Places
//
//  Created by Apple on 8/28/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "FlickrFetcherModification.h"

@implementation FlickrFetcherModification

+ (void)downloadTopPlaces:(void (^)(NSArray *places, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url
                                                completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                    NSArray *places;
                                                    if (!error) {
                                                        places = [[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:0 error:&error] valueForKeyPath:FLICKR_RESULTS_PLACES];
                                                    }
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        completionHandler(places, error);
                                                    });
                                                }];
    [task resume];
}

+ (void)downloadPhotosForPlace:(NSDictionary *)place numOfResults:(int)results onCompletion:(void (^)(NSArray *photos, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURL *url = [FlickrFetcherModification URLforPhotosInPlace:[place valueForKeyPath:FLICKR_PLACE_ID] maxResults:results];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url
                                                completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                    NSArray *photos;
                                                    if (!error) {
                                                        photos = [[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:0 error:&error] valueForKeyPath:FLICKR_RESULTS_PHOTOS];
                                                    }
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        completionHandler(photos, error);
                                                    });
                                                }];
    [task resume];
}

+ (NSString *)countryOfPlace:(NSDictionary *)place {
    return [[[place valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
}

+ (NSString *)titleOfPlace:(NSDictionary *)place {
    return [place valueForKey:@"woe_name"];
}

+ (NSString *)subtitleOfPlace:(NSDictionary *)place {
    NSArray *partsOfPlace = [[place valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
    NSRange range;
    range.location = 1;
    range.length = [partsOfPlace count] - 2;
    return [[partsOfPlace subarrayWithRange:range] componentsJoinedByString:@", "];
}

+ (NSArray *)sortPlaces:(NSArray *)places {
    return [places sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *place1 = [obj1 valueForKey:@"woe_name"];
        NSString *place2 = [obj2 valueForKey:@"woe_name"];
        return [place1 caseInsensitiveCompare:place2];
    }];
}

+ (NSDictionary *)placesByCountries:(NSArray *)places {
    NSMutableDictionary *placesByCountry = [NSMutableDictionary dictionary];
    for (NSDictionary *place in places) {
        NSString *country = [FlickrFetcherModification countryOfPlace:place];
        NSMutableArray *placesOfCountry = placesByCountry[country];
        if (!placesOfCountry) {
            placesOfCountry = [NSMutableArray array];
            placesByCountry[country] = placesOfCountry;
        }
        [placesOfCountry addObject:place];
    }
    return placesByCountry;
}

+ (NSArray *)countries:(NSDictionary *)placesByCountries {
    NSArray *countries = [placesByCountries allKeys];
    return [countries sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
}

@end
