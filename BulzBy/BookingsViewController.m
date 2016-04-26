//
//  BookingsViewController.m
//  BulzBy
//
//  Created by Seby Feier on 21/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "BookingsViewController.h"
#import "BookingTableViewCell.h"

@implementation BookingsViewController


- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.allRestaurants.count;
    if (tableView == self.tableView) {
        return self.myBookings.count;
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
        BookingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingTableViewCellIdentifier"];
        if (!cell) {
            cell = [[BookingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookingTableViewCellIdentifier"];
        }
        NSDictionary *cellInfo = [self.myBookings objectAtIndex:indexPath.row];
        [cell updateCellWithInfo:cellInfo];
        return cell;
    }
    return nil;
}
@end
