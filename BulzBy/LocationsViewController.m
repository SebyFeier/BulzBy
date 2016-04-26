//
//  LocationsViewController.m
//  BulzBy
//
//  Created by Seby Feier on 19/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "LocationsViewController.h"
#import "HexColors.h"
#import "LocationsTableViewCell.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"
#import "LocationRestaurantsViewController.h"

@implementation LocationsViewController

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, tableView.frame.size.width, 25)];
    //    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSDictionary *countryLocation = [self.allLocations objectAtIndex:section];
    NSString *string = [countryLocation objectForKey:@"name"];
    /* Section header is in 0th index... */
    [label setText:string];
    //    [label setTextColor:[UIColor colorFromHexString:@"c1c1c1"]];
    [label setTextColor:[HXColor hx_colorWithHexString:@"c1c1c1"]];
    [view addSubview:label];
    //    [view setBackgroundColor:[UIColor colorFromHexString:@"f1eef1"]];
    [view setBackgroundColor:[HXColor hx_colorWithHexString:@"f1eef1"]];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allLocations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.allLocations objectAtIndex:section] objectForKey:@"cities"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationsTableViewCellIdentifier"];
    if (!cell) {
        cell = [[LocationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationsTableViewCellIdentifier"];
    }
    NSDictionary *countryLocation = [self.allLocations objectAtIndex:indexPath.section];
    NSArray *locations = [countryLocation objectForKey:@"cities"];
    NSDictionary *location = [locations objectAtIndex:indexPath.row];
    cell.titleLabel.text = location[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *countryLocation = [self.allLocations objectAtIndex:indexPath.section];
    NSArray *locations = [countryLocation objectForKey:@"cities"];
    NSDictionary *location = [locations objectAtIndex:indexPath.row];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getListOfRestaurantsWithPageNumber:[NSNumber numberWithInteger:1] categoryId:nil cityId:location[@"id"] name:nil andCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        LocationRestaurantsViewController *locationRestaurantsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationRestaurantsViewControllerIdentifier"];
        locationRestaurantsViewController.allRestaurants = [[NSMutableArray alloc] initWithArray:array];
        locationRestaurantsViewController.cityId = location[@"id"];
        locationRestaurantsViewController.cityName = location[@"name"];
        [self.navigationController pushViewController:locationRestaurantsViewController animated:YES];
    }];
}
@end
