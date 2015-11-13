//
//  InitialViewController.m
//  unit-3-final-project
//
//  Created by Shena Yoshida on 11/8/15.
//  Copyright © 2015 Shena Yoshida. All rights reserved.
//

#import "InitialViewController.h"
#import "CustomPin.h"
#import <AFNetworking/AFNetworking.h>
#import "ArtistInfoData.h"

@interface InitialViewController () <MKMapViewDelegate, UISearchBarDelegate>

// for collection view
@property (nonatomic) NSMutableArray *array;
@property (nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// for maps
@property (nonatomic) CLLocationManager *locationManager;

//for API search results
@property (nonatomic) NSMutableArray *searchResults;

//search bar/colleciton view
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSArray *dataSourceForSearchResult;
@property (nonatomic) BOOL searchBarActive;

@property (nonatomic,strong) UIRefreshControl   *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end


@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // dummy data for collection view:
     self.array = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    
    // for carousel
    // grab references to first and last items
    id firstItem = [self.array firstObject];
    id lastItem = [self.array lastObject];
    
    NSMutableArray *workingArray = [self.array mutableCopy];
    
    // add the copy of the last item to the beginning
    [workingArray insertObject:lastItem atIndex:0];
    
    // add the copy of the first item to the end
    [workingArray addObject:firstItem];
    //[workingArray insertObject:firstItem atIndex:self.array.count];
    
    // update the collection view's data source property
    self.dataArray = [NSArray arrayWithArray:workingArray];
    
    // make cells stick in view
    [self.collectionView setPagingEnabled:YES];
    
    
    //current location
    [self pin];
    [self getCurrentLocation];
    
    self.searchBar.delegate = self; 
}


#pragma mark - search bar
//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
//    NSPredicate *resultPredicate    = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
//    self.dataSourceForSearchResult  = [self.dataSource filteredArrayUsingPredicate:resultPredicate];
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    // user did type something, check our datasource for text that looks the same
//    if (searchText.length>0) {
//        // search and reload data source
//        self.searchBarActive = YES;
//        [self filterContentForSearchText:searchText
//                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                          objectAtIndex:[self.searchDisplayController.searchBar
//                                                         selectedScopeButtonIndex]]];
//        [self.collectionView reloadData];
//    }else{
//        // if text lenght == 0
//        // we will consider the searchbar is not active
//        self.searchBarActive = NO;
//    }
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [self cancelSearching];
//    [self.collectionView reloadData];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    self.searchBarActive = YES;
//    [self.view endEditing:YES];
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    // we used here to set self.searchBarActive = YES
//    // but we'll not do that any more... it made problems
//    // it's better to set self.searchBarActive = YES when user typed something
//    [self.searchBar setShowsCancelButton:YES animated:YES];
//}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    // this method is being called when search btn in the keyboard tapped
//    // we set searchBarActive = NO
//    // but no need to reloadCollectionView
//    self.searchBarActive = NO;
//    [self.searchBar setShowsCancelButton:NO animated:YES];
//    
//    [self artistInfo];
//}
//
//-(void)cancelSearching{
//    self.searchBarActive = NO;
//    [self.searchBar resignFirstResponder];
//    self.searchBar.text  = @"";
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
     [self.view endEditing:YES];
    
    [self artistInfo];
}

#pragma mark- Echonest API Request

- (void)artistInfo{
    
    NSMutableArray *cities = [[NSMutableArray alloc] init];
    [cities addObject:@"New York"];
    [cities addObject:@"Brooklyn"];
    [cities addObject:@"Queens"];
    [cities addObject:@"Holbrook"];
    [cities addObject:@"Fort Greene"];
    [cities addObject:@"Ozone Park"];
    [cities addObject:@"Holbrook"];
    [cities addObject:@"Hoboken"];
    [cities addObject:@"Harlem"];
    [cities addObject:@"Flushing"];
    
    
    //   http://developer.echonest.com/api/v4/artist/search?api_key=MUIMT3R874QGU0AFO&format=json&artist_location=city:washington&bucket=artist_location
    
    NSString *url = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/search?api_key=MUIMT3R874QGU0AFO&format=json&artist_location=city:%@&bucket=artist_location&bucket=biographies&bucket=images&bucket=years_active", self.searchBar.text];
    
    NSString *encodedString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] init];
    
    [manager GET:encodedString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSDictionary *results = responseObject[@"response"];
        NSArray *artists = results[@"artists"];
        
        // reset my array
        self.searchResults = [[NSMutableArray alloc] init];
        
        // loop through all json posts
        for (NSDictionary *results in artists) {
            
            // create new post from json
            artistInfoData *data = [[artistInfoData alloc] initWithJSON:results];
            
       
            // add post to array
            [self.searchResults  addObject:data];
            
            //            self.albumImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:data.imageURL]]];
            
            NSLog(@"This is the artist data: %@",data);
        }
        
        
        // [self.tableView reloadData];
        NSLog(@"%@", results);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error.localizedDescription);
        // block();
    }];
}


#pragma mark - collection view methods: 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell"; // set collection view cell identifier name
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
   // UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
 
    
    // round corners
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.cornerRadius = 10.0;
    
    return cell;
}

#pragma mark - infinite scrolling: 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // calculate where the collection view should be at the right-hand end item
    float contentOffsetWhenFullyScrolledRight = self.collectionView.frame.size.width * ([self.dataArray count] -1);
    
    if (scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        
        // user is scrolling to the right from the last item to the 'fake' item 1.
        // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    } else if (scrollView.contentOffset.x == 0) {
        
        // user is scrolling to the left from the first item to the fake item
        // reposition offset to show the "real" item at the right end of the collection
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.dataArray count] -2) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    }
}

#pragma mark - Maps:

//current location
- (void)getCurrentLocation {
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;
    
    self.locationManager = [CLLocationManager new];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}
// zoom in
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:10000];
    [mapView setCamera:camera animated:YES];
    
}
//annimated pin
- (void)pin {
    CLLocationCoordinate2D location;
    location.latitude = 40.744731;
    location.longitude = -73.933547;
    
    CustomPin *pin = [CustomPin alloc];
    pin.coordinate = location;
    pin.title = @"Long Island City, NY";
    [self.mapView addAnnotation:pin];
}
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;

    if(annotation != self.mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        //        [self.customView setBackgroundColor:[UIColor redColor]];
        //        [pinView addSubview:self.customView];
        pinView.image = [UIImage imageNamed:@"Pin.png"];
    }
    else {
        [self.mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
