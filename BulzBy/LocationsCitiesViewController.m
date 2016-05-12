//
//  LocationsCitiesViewController.m
//  BulzBy
//
//  Created by Sebastian Feier on 5/12/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "LocationsCitiesViewController.h"
#import "LocationsTableViewCell.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"
#import "LocationRestaurantsViewController.h"

@interface LocationsCitiesViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSArray *searchedLocations;
}

@end

@implementation LocationsCitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.countryNameTitle.text = self.countryName;
    searchedLocations = [NSArray arrayWithArray:self.allLocations];
    // Do any additional setup after loading the view.
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30;
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.allLocations.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return [[[self.allLocations objectAtIndex:section] objectForKey:@"cities"] count];
    return [self.allLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationsTableViewCellIdentifier"];
    if (!cell) {
        cell = [[LocationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationsTableViewCellIdentifier"];
    }
    NSDictionary *countryLocation = [self.allLocations objectAtIndex:indexPath.row];
    //    NSArray *locations = [countryLocation objectForKey:@"cities"];
    //    NSDictionary *location = [locations objectAtIndex:indexPath.row];
    cell.titleLabel.text = countryLocation[@"name"];
    return cell;
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *countryLocation = [self.allLocations objectAtIndex:indexPath.row];
//    NSArray *locations = [countryLocation objectForKey:@"cities"];
//    NSDictionary *location = [locations objectAtIndex:indexPath.row];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//    [[WebServiceManager sharedInstance] getCitiesFromCountry:[NSNumber numberWithInteger:[location[@"id"] integerValue]] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
//        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//    }];
        [[WebServiceManager sharedInstance] getListOfRestaurantsWithPageNumber:[NSNumber numberWithInteger:1] categoryId:nil cityId:countryLocation[@"id"] name:nil andCompletionBlock:^(NSArray *array, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            LocationRestaurantsViewController *locationRestaurantsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationRestaurantsViewControllerIdentifier"];
            locationRestaurantsViewController.allRestaurants = [[NSMutableArray alloc] initWithArray:array];
            locationRestaurantsViewController.cityId = countryLocation[@"id"];
            locationRestaurantsViewController.cityName = countryLocation[@"name"];
            [self.navigationController pushViewController:locationRestaurantsViewController animated:YES];
        }];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    self.allLocations = [NSMutableArray arrayWithArray:searchedLocations];
    [self.tableView reloadData];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [self.view endEditing:YES];
    }
    if (searchText.length >= 3) {
//        NSString *str = sea;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"name contains [cd] %@", searchText];
        NSArray *result = [searchedLocations filteredArrayUsingPredicate:pred];
        self.allLocations = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
        
    } else {
        self.allLocations = [NSMutableArray arrayWithArray:searchedLocations];
        [self.tableView reloadData];
    }
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
