//
//  LocationRestaurantsViewController.m
//  BulzBy
//
//  Created by Seby Feier on 19/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "LocationRestaurantsViewController.h"
#import "HomeTableViewCell.h"
#import "DetailsViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"
#import "MapViewController.h"

@implementation LocationRestaurantsViewController

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)mapButtonTapped:(id)sender {
    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewControllerIdentifier"];
    NSMutableArray *allLocations = [[NSMutableArray alloc] init];
    for (NSDictionary *restaurant in self.allRestaurants) {
        [allLocations addObjectsFromArray:restaurant[@"locations"]];
    }
    mapViewController.allLocations = allLocations;
    mapViewController.allRestaurants = self.allRestaurants;
    mapViewController.isRoute = NO;
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNumber = 2;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationTitleLabel.text = self.cityName;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.allRestaurants.count;
    if (tableView == self.tableView) {
        return self.allRestaurants.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return 65;
    }
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCellIdentifier"];
        if (!cell) {
            cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeTableViewCellIdentifier"];
        }
        NSDictionary *cellInfo = [self.allRestaurants objectAtIndex:indexPath.row];
        [cell updateCellWithInfo:cellInfo];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        NSDictionary *restaurantInfo = [self.allRestaurants objectAtIndex:indexPath.row];
//        DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewControllerIdentifier"];
//        detailsViewController.restaurantInfo = restaurantInfo;
//        [self.navigationController pushViewController:detailsViewController animated:YES];
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] getCompanyInformationWithId:restaurantInfo[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewControllerIdentifier"];
            detailsViewController.restaurantInfo = dictionary;
            [self.navigationController pushViewController:detailsViewController animated:YES];
            
        }];

        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.tableView) {
//        if (indexPath.row == self.allRestaurants.count - 3) {
//            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//            [[WebServiceManager sharedInstance] showUserDetailsWithApiToken:[[[WebServiceManager sharedInstance] userInfo] objectForKey:@"api_token"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
//                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//                if (!error) {
//                    if (dictionary[@"bookings"] && [dictionary[@"bookings"] count] > self.allRestaurants.count) {
//                        [self.allRestaurants addObjectsFromArray:dictionary[@"bookings"]];
//                        _pageNumber++;
//                        [self.tableView reloadData];
//                    }
//                } else {
//                    [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                }
//
//            }];
//        }
//    }
}
@end
