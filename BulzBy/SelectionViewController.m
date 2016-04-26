//
//  SelectionViewController.m
//  BulzBy
//
//  Created by Seby Feier on 19/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "SelectionViewController.h"

@interface SelectionViewController()<UITableViewDataSource, UITableViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    //    self.navigationItem.hidesBackButton = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    NSDictionary *selection = [self.allSelections objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectionDidSelect:)]) {
        [self.delegate selectionDidSelect:selection];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allSelections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [[[self.allSelections objectAtIndex:section] objectForKey:@"cities"] count];
    return [self.allSelections count];
}

@end

