//
//  ViewController.m
//  BulzBy
//
//  Created by Seby Feier on 14/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "ViewController.h"
#import "HomeTableViewCell.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"
#import "Haneke.h"
#import "MenuTableViewCell.h"
#import "DetailsViewController.h"
#import "MapViewController.h"
#import "LoginViewController.h"
#import "LocationsViewController.h"
//#import "WebViewViewController.h"
#import "EmailViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource> {
    BOOL menuIsShown;
    NSInteger pageNumber;
    NSString *categoryId;
    NSString *cityId;
    NSString *name;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = 1;
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    categoryId = nil;
    name = nil;
    cityId = nil;
    [[WebServiceManager sharedInstance] getListOfRestaurantsWithPageNumber:[NSNumber numberWithInteger:pageNumber] categoryId:categoryId cityId:cityId name:name andCompletionBlock:^(NSArray *array, NSError *error) {
        if (!error ) {
            pageNumber++;
            self.allRestaurants = [[NSMutableArray alloc] initWithArray:array];
            [self.tableView reloadData];
            [[WebServiceManager sharedInstance] getListOfCategoriesWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                if (!error) {
                    self.allCategories = [[NSMutableArray alloc] initWithArray:dictionary[@"categories"]];
                    self.allCountries = [[NSMutableArray alloc] initWithArray:dictionary[@"countries"]];
                    [[NSUserDefaults standardUserDefaults] setObject:self.allCountries forKey:@"allCountries"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.allCategories addObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Locations", nil) forKey:@"name"]];
                    [self.allCategories addObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"My Account", nil) forKey:@"name"]];
                    [self.allCategories addObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Contact", nil) forKey:@"name"]];
                    [self.menuTableView reloadData];
                } else {
                    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                }
            }];
        } else {
            [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    if (!self.menuTableView) {
        self.menuTableView = [[MenuTableView alloc] initWithFrame:CGRectMake(-200, 62, 200, CGRectGetHeight(self.tableView.frame))];
        self.menuTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sidebar_bg.png"]];
        [self.view addSubview:self.menuTableView];
    }
    [self.menuTableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:@"MenuTableViewCellIdentifier"];

    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    menuIsShown = NO;
    self.menuTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.allRestaurants.count;
    if (tableView == self.tableView) {
        return self.allRestaurants.count;
    } else if (tableView == self.menuTableView) {
        return self.allCategories.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return 65;
    } else if (tableView == self.menuTableView) {
        return 44;
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
    } else if (tableView == self.menuTableView) {
        MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCellIdentifier"];
        if (!cell) {
            cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableViewCellIdentifier"];
        }
        NSLog(@"%ld",(long)indexPath.row);
        NSDictionary *category = [self.allCategories objectAtIndex:indexPath.row];
        if (indexPath.row == [self.allCategories count] - 3) {
            [cell uppdateCellWithInfo:category withImage:@"location512"];
        } else if (indexPath.row == [self.allCategories count] - 2) {
            [cell uppdateCellWithInfo:category withImage:@"user"];
        } else if (indexPath.row == [self.allCategories count] - 1) {
            [cell uppdateCellWithInfo:category withImage:@"contactIcon"];
        }else {
            [cell updateCellWithInfo:category];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        NSDictionary *restaurantInfo = [self.allRestaurants objectAtIndex:indexPath.row];
        [[WebServiceManager sharedInstance] getCompanyInformationWithId:restaurantInfo[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewControllerIdentifier"];
            detailsViewController.restaurantInfo = dictionary;
            [self.navigationController pushViewController:detailsViewController animated:YES];
            
        }];
        
    } else if (tableView == self.menuTableView) {
        if (indexPath.row == [self.allCategories count] - 1) {
//            WebViewViewController *webViewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewControllerIdentifier"];
//            webViewViewController.urlString = @"https://www.anuntul.co.uk/pagina/intrebari-si-raspunsuri/";
//            [self.navigationController pushViewController:webViewViewController animated:YES];
            EmailViewController *emailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewControllerIdentifier"];
            [self.navigationController pushViewController:emailViewController animated:YES];

        } else if (indexPath.row == [self.allCategories count] - 2) {
            LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerIdentifier"];
            loginViewController.shouldReturn = NO;
            [self.navigationController pushViewController:loginViewController animated:YES];
        } else if (indexPath.row == [self.allCategories count] - 3) {
            LocationsViewController *locationsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationsViewControllerIdentifier"];
            locationsViewController.allLocations = self.allCountries;
            [self.navigationController pushViewController:locationsViewController animated:YES];
            
        } else {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
            pageNumber = 1;
            NSDictionary *categoryInfo = [self.allCategories objectAtIndex:indexPath.row];
            categoryId = [NSString stringWithFormat:@"%@",categoryInfo[@"id"]];
            //        name = [NSString stringWithFormat:@"%@",restaurantInfo[@"name"]];
            
            [[WebServiceManager sharedInstance] getListOfRestaurantsWithPageNumber:[NSNumber numberWithInteger:pageNumber] categoryId:categoryId cityId:cityId name:name andCompletionBlock:^(NSArray *array, NSError *error) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                pageNumber++;
                self.allRestaurants = [[NSMutableArray alloc] initWithArray:array];
                [UIView animateWithDuration:0.25 animations:^{
                    self.menuTableView.frame = CGRectMake(-200, 62, 200, CGRectGetHeight(self.tableView.frame));
                }];
                menuIsShown = !menuIsShown;
                [self.tableView reloadData];
            }];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.row == self.allRestaurants.count - 3) {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
            [[WebServiceManager sharedInstance] getListOfRestaurantsWithPageNumber:[NSNumber numberWithInteger:pageNumber] categoryId:categoryId cityId:cityId name:name andCompletionBlock:^(NSArray *array, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                if (!error) {
                    if (array && [array count]) {
                        [self.allRestaurants addObjectsFromArray:array];
                        pageNumber++;
                        [self.tableView reloadData];
                    }
                } else {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }                
            }];
        }
    }
}


- (IBAction)menuButtonTapped:(id)sender {
    if (!menuIsShown) {
        [UIView animateWithDuration:0.25 animations:^{
            //        [self.view layoutIfNeeded];
            self.menuTableView.frame = CGRectMake(0, 62, 200, CGRectGetHeight(self.tableView.frame));
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.menuTableView.frame = CGRectMake(-200, 62, 200, CGRectGetHeight(self.tableView.frame));
        }];
    }
    menuIsShown = !menuIsShown;
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

@end
