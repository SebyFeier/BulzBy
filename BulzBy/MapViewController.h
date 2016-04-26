//
//  MapViewController.h
//  BulzBy
//
//  Created by Seby Feier on 16/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate> {
    int flag_Map;
    int annotationTag;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *restaurantDetails;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UIButton *restaurantInfoButton;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *allLocations;
@property (nonatomic, strong) NSMutableArray *allRestaurants;

@property (nonatomic, assign) BOOL isRoute;


@end
