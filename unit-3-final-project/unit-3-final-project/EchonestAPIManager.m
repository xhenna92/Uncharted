//
//  EchonestAPIManager.m
//  unit-3-final-project
//
//  Created by Henna Ahmed on 11/15/15.
//  Copyright © 2015 Shena Yoshida. All rights reserved.
//

#import "EchonestAPIManager.h"
#import "LocationInfoObject.h"
#import "ArtistInfoData.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@implementation EchonestAPIManager

+ (void)getArtistInfoForCities:(NSArray <LocationInfoObject *> *)cities
                      andGenre:(NSString*)genre
                    completion:(void(^)())completion {
    __block int received = 0;
    for (LocationInfoObject *city in cities) {
        [self getAristInfoForCity:city andGenre:genre completion:^(NSArray *artists) {
            
            if (artists) {
                city.artists = artists;
            }
            
            received++;
            
            if (received == cities.count) {
                completion();
            }
        }];
    }
}

+ (void)getAristInfoForCity:(LocationInfoObject *)city
                   andGenre:(NSString*)genre
                 completion:(void(^)(NSArray *artists))completion {
    
    NSString *url = [[NSString alloc]init];
    
    if (![genre isEqualToString:@" "]) {
        url = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/search?api_key=MUIMT3R874QGU0AFO&format=json&artist_location=%@+%@&bucket=artist_location&bucket=biographies&bucket=images&bucket=years_active&bucket=genre&bucket=discovery_rank&bucket=familiarity_rank&bucket=hotttnesss_rank&style=%@", city.SubAdministrativeArea, city.State, genre];
    }
    else{
        url = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/search?api_key=MUIMT3R874QGU0AFO&format=json&artist_location=%@+%@&bucket=artist_location&bucket=biographies&bucket=images&bucket=years_active&bucket=genre&bucket=discovery_rank&bucket=familiarity_rank&bucket=hotttnesss_rank", city.SubAdministrativeArea, city.State];
    }
    
    NSLog(@"%@", url);
    
    NSString *encodedString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] init];
    [manager GET:encodedString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *results = responseObject[@"response"];
        NSArray *artists = results[@"artists"];
        
        NSMutableArray *stuff = [[NSMutableArray alloc] init];
        
        // loop through all json posts
        for (NSDictionary *result in artists) {
            
            // create new post from json
            ArtistInfoData *data = [[ArtistInfoData alloc] initWithJSON:result];
            [stuff addObject:data];
        }
        
        completion(stuff);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error.localizedDescription);
        completion(nil);
    }];
}


@end
