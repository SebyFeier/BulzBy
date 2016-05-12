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
#import "SelectionViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SelectionDelegate> {
    BOOL menuIsShown;
    NSInteger pageNumber;
    NSString *categoryId;
    NSString *cityId;
    NSString *name;
    BOOL _isSearch;
    NSDictionary *selectedCategory;
    NSDictionary *selectedLocation;
    NSMutableArray *searchCategories;
    NSMutableArray *searchLocations;
    BOOL _searchResultsRequired;
    BOOL isCategorySelected;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchWidthConstraint;
@property (weak, nonatomic) IBOutlet UITextField *keyWordsTextField;
@property (weak, nonatomic) IBOutlet UIButton *locationsButton;
@property (weak, nonatomic) IBOutlet UIButton *categoriesButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation ViewController

- (void)closeSearchView:(UIPanGestureRecognizer *)gesture {
    CGPoint vel = [gesture velocityInView:self.view];
//    if (vel.x < 0)
//        if (self.searchTrailingConstraint.constant == 0) {
////            NSString *string = [[WebServiceManager sharedInstance] categoryName];
////            self.navigationItem.title = string;
////            self.tabBarController.navigationItem.title = string;
//            
//            self.searchTrailingConstraint.constant = -CGRectGetWidth(self.view.frame);
//            [UIView animateWithDuration:0.25 animations:^{
//                [self.view layoutIfNeeded];
//                [self.view endEditing:YES];
//                _isSearch = !_isSearch;
//            }];
//        }
        [self menuButtonTapped:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = 1;
    _isSearch = NO;
    _searchResultsRequired = NO;
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    categoryId = nil;
    name = nil;
    cityId = nil;
    self.keyWordsTextField.placeholder = NSLocalizedString(@"Search", nil);
    [self.searchButton setTitle:NSLocalizedString(@"Search", nil) forState:UIControlStateNormal];
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
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.allCategories addObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Locations", nil) forKey:@"name"]];
                    [self.allCategories addObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"My Account", nil) forKey:@"name"]];
                    [self.allCategories addObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Contact", nil) forKey:@"name"]];
                    [self.allCategories addObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Map", nil) forKey:@"name"]];
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
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeSearchView:)];
    [self.menuTableView addGestureRecognizer:panGesture];

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
        if (indexPath.row == [self.allCategories count] - 4) {
            [cell uppdateCellWithInfo:category withImage:@"location512"];
        } else if (indexPath.row == [self.allCategories count] - 3) {
            [cell uppdateCellWithInfo:category withImage:@"user"];
        } else if (indexPath.row == [self.allCategories count] - 2) {
            [cell uppdateCellWithInfo:category withImage:@"contactIcon"];
        } else if (indexPath.row == [self.allCategories count] - 1) {
            [cell uppdateCellWithInfo:category withImage:@"map512"];
        } else {
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
            MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewControllerIdentifier"];
            NSMutableArray *allLocations = [[NSMutableArray alloc] init];
            for (NSDictionary *restaurant in self.allRestaurants) {
                [allLocations addObjectsFromArray:restaurant[@"locations"]];
            }
            mapViewController.allLocations = allLocations;
            mapViewController.allRestaurants = self.allRestaurants;
            mapViewController.isRoute = NO;
            [self.navigationController pushViewController:mapViewController animated:YES];
        } else if (indexPath.row == [self.allCategories count] - 2) {
//            WebViewViewController *webViewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewControllerIdentifier"];
//            webViewViewController.urlString = @"https://www.anuntul.co.uk/pagina/intrebari-si-raspunsuri/";
//            [self.navigationController pushViewController:webViewViewController animated:YES];
            EmailViewController *emailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewControllerIdentifier"];
            [self.navigationController pushViewController:emailViewController animated:YES];

        } else if (indexPath.row == [self.allCategories count] - 3) {
            LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerIdentifier"];
            loginViewController.shouldReturn = NO;
            [self.navigationController pushViewController:loginViewController animated:YES];
        } else if (indexPath.row == [self.allCategories count] - 4) {
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
//    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewControllerIdentifier"];
//    NSMutableArray *allLocations = [[NSMutableArray alloc] init];
//    for (NSDictionary *restaurant in self.allRestaurants) {
//        [allLocations addObjectsFromArray:restaurant[@"locations"]];
//    }
//    mapViewController.allLocations = allLocations;
//    mapViewController.allRestaurants = self.allRestaurants;
//    mapViewController.isRoute = NO;
//    [self.navigationController pushViewController:mapViewController animated:YES];
    self.searchWidthConstraint.constant = CGRectGetWidth(self.view.frame);
    if (!_isSearch) {
//        self.navigationItem.title = @"Căutare";
//        self.tabBarController.navigationItem.title = @"Căutare";
        
        searchCategories = [NSMutableArray arrayWithArray:self.allCategories];
        //        [allCategories removeObjectAtIndex:0];
        [searchCategories removeLastObject];
        [searchCategories removeLastObject];
        [searchCategories removeLastObject];
        [searchCategories removeLastObject];
        //        [allCategories removeLastObject];
        //        [allCategories removeLastObject];
        
        //        allLocations = [[NSMutableArray alloc] init];
        //        NSArray *locations = [[WebServiceManager sharedInstance] listOfLocations];
        //        for (NSDictionary *location in locations) {
        //            [allLocations addObjectsFromArray:location[@"locations"]];
        //        }
        searchLocations = [NSMutableArray arrayWithArray:self.allCountries];
        [searchLocations insertObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"All locations", nil) forKey:@"name"] atIndex:0];
        [searchCategories insertObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"All categories", nil) forKey:@"name"] atIndex:0];
        selectedLocation = [searchLocations firstObject];
        selectedCategory = [searchCategories firstObject];
        //        self.locationsTextField.text = selectedLocation[@"titlu"];
        [self.locationsButton setTitle:selectedLocation[@"name"] forState:UIControlStateNormal];
        //        self.categoriesTextField.text = selectedCategory[@"titlu"];
        [self.categoriesButton setTitle:selectedCategory[@"name"] forState:UIControlStateNormal];
        
        _searchTrailingConstraint.constant = 0;
    } else {
        //        NSString *string = [[WebServiceManager sharedInstance] categoryName];
        //        self.navigationItem.title = string;
        //        self.tabBarController.navigationItem.title = string;
        _searchTrailingConstraint.constant = -CGRectGetWidth(self.view.frame);
    }
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.view endEditing:YES];
    _isSearch = !_isSearch;

}

- (IBAction)searchButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    pageNumber = 1;
    name = self.keyWordsTextField.text;
    [[WebServiceManager sharedInstance] getListOfRestaurantsWithPageNumber:[NSNumber numberWithInteger:pageNumber] categoryId:selectedCategory[@"id"] cityId:selectedLocation[@"id"] name:self.keyWordsTextField.text andCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        pageNumber++;
        self.allRestaurants = [[NSMutableArray alloc] initWithArray:array];
        [UIView animateWithDuration:0.25 animations:^{
            self.menuTableView.frame = CGRectMake(-200, 62, 200, CGRectGetHeight(self.tableView.frame));
        }];
        self.searchTrailingConstraint.constant = -CGRectGetWidth(self.view.frame);
        menuIsShown = !menuIsShown;
        _isSearch = !_isSearch;
        [self.tableView reloadData];
    }];
}
- (IBAction)locationsButtonTapped:(id)sender {
    [self.view endEditing:YES];
    SelectionViewController *selectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionViewControllerIdentifier"];
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:self.allCountries];
    [locations insertObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"All locations", nil) forKey:@"name"] atIndex:0];
    selectionViewController.allSelections = locations;
    selectionViewController.delegate = self;
    selectionViewController.requiresStep2 = YES;
    [self.navigationController pushViewController:selectionViewController animated:YES];
    isCategorySelected = NO;


}

- (IBAction)categoriesButtonTapped:(id)sender {
    [self.view endEditing:YES];
    SelectionViewController *selectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionViewControllerIdentifier"];
    NSMutableArray *categories = [NSMutableArray arrayWithArray:self.allCategories];
    //        [allCategories removeObjectAtIndex:0];
    [categories removeLastObject];
    [categories removeLastObject];
    [categories removeLastObject];
    [categories removeLastObject];
    [categories insertObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"All categories", nil) forKey:@"name"] atIndex:0];
    selectionViewController.allSelections = categories;
    selectionViewController.delegate = self;
    selectionViewController.requiresStep2 = NO;
    [self.navigationController pushViewController:selectionViewController animated:YES];
    isCategorySelected = YES;
}

- (void)selectionDidSelect:(NSDictionary *)selection {
    if (isCategorySelected) {
        selectedCategory = selection;
        [self.categoriesButton setTitle:selection[@"name"] forState:UIControlStateNormal];
    } else {
        selectedLocation = selection;
        [self.locationsButton setTitle:selection[@"name"] forState:UIControlStateNormal];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
@end
