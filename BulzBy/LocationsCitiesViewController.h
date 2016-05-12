//
//  LocationsCitiesViewController.h
//  BulzBy
//
//  Created by Sebastian Feier on 5/12/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationsCitiesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allLocations;
@property (nonatomic, strong) NSString *countryName;
@property (weak, nonatomic) IBOutlet UILabel *countryNameTitle;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
