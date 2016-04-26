//
//  MapViewController.m
//  BulzBy
//
//  Created by Seby Feier on 16/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "MapViewController.h"
#import "CustomPointAnnotationView.h"
#import "DetailsViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    flag_Map = 1;
    self.restaurantDetails.hidden = YES;
    if (self.isRoute) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        self.mapView.showsUserLocation = YES;
        
        [self.locationManager startUpdatingLocation];
        
    }
    for (int i=0 ; i< self.allLocations.count; i++)
    {
        NSMutableDictionary *dict_data = [self.allLocations objectAtIndex:i];

        double lat = [[dict_data objectForKey:@"latitude"] doubleValue];
        double longt = [[dict_data objectForKey:@"longitude"] doubleValue];
        
        CLLocationCoordinate2D loc;
        loc.longitude = longt;
        loc.latitude = lat;
        CustomPointAnnotationView *annotationPoint = [[CustomPointAnnotationView alloc] init];
        annotationPoint.coordinate = loc;
        if (!self.isRoute) {
            annotationPoint.tag = [[dict_data objectForKey:@"id"] integerValue];
            annotationPoint.title = [dict_data objectForKey:@"name"];
            annotationPoint.subtitle = [dict_data objectForKey:@"address"];
        }
        
        [self.mapView addAnnotation:annotationPoint];
    }
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.0, 0.0);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(40, 10, 10, 10) animated:YES];
    

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if (!self.isRoute) {
        if ([annotation isKindOfClass:[MKUserLocation class]])
            return nil;
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.pinColor = MKPinAnnotationColorRed;
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            rightButton.tag = [(CustomPointAnnotationView *)annotation tag];
            [rightButton addTarget:self action:@selector(restaurantInfoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
            
            return pinView;
        }
    } else {
        
    }
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.0, 0.0);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(40, 10, 10, 10) animated:YES];
}

- (IBAction)restaurantInfoButtonTapped:(id)sender {
    NSDictionary *restaurantInfo = nil;
    UIButton *button = (UIButton *)sender;
    for (NSDictionary *locationInfo in self.allLocations) {
        if ([[locationInfo objectForKey:@"id"] integerValue] == button.tag) {
            for (NSDictionary *restaurant in self.allRestaurants) {
                for (NSDictionary *location in restaurant[@"locations"]) {
                    if ([[location objectForKey:@"id"] integerValue] == [[locationInfo objectForKey:@"id"] integerValue]) {
                        restaurantInfo = restaurant;
                        break;
                    }
                }
            }
        }
    }
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getCompanyInformationWithId:restaurantInfo[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewControllerIdentifier"];
        detailsViewController.restaurantInfo = dictionary;
        [self.navigationController pushViewController:detailsViewController animated:YES];
        
    }];
    
    
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
