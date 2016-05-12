//
//  SelectionStep2ViewController.m
//  BulzBy
//
//  Created by Sebastian Feier on 5/12/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "SelectionStep2ViewController.h"

@interface SelectionStep2ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSMutableArray *searchedLocations;
}

@end

@implementation SelectionStep2ViewController

- (void)viewDidLoad {
    //    self.navigationItem.hidesBackButton = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    searchedLocations = [NSMutableArray arrayWithArray:self.allSelections];
    self.countryNameLabel.text = self.countryName;
    [self.allSelections insertObject:[NSDictionary dictionaryWithObject:NSLocalizedString(@"All cities", nil) forKey:@"name"] atIndex:0];
    [super viewDidLoad];
}
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionTableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionTableViewCellIdentifier"];
    }
    //    NSDictionary *countryLocation = [self.allSelections objectAtIndex:indexPath.section];
    //    NSArray *locations = [countryLocation objectForKey:@"cities"];
    //    NSDictionary *location = [locations objectAtIndex:indexPath.row];
    NSDictionary *location = [self.allSelections objectAtIndex:indexPath.row];
    cell.textLabel.text = location[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSDictionary *countryLocation = [self.allSelections objectAtIndex:indexPath.section];
    //    NSArray *locations = [countryLocation objectForKey:@"cities"];
    //    NSDictionary *selection = [locations objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *selection = [self.allSelections objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectionStep2DidSelect:)]) {
        [self.delegate selectionStep2DidSelect:selection];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.allSelections.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return [[[self.allSelections objectAtIndex:section] objectForKey:@"cities"] count];
    return [self.allSelections count];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    self.allSelections = [NSMutableArray arrayWithArray:searchedLocations];
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
        self.allSelections = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
        
    } else {
        self.allSelections = [NSMutableArray arrayWithArray:searchedLocations];
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
