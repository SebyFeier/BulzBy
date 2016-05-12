//
//  SelectionViewController.m
//  BulzBy
//
//  Created by Seby Feier on 19/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "SelectionViewController.h"
#import "SelectionStep2ViewController.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"

@interface SelectionViewController()<UITableViewDataSource, UITableViewDelegate, SelectionStep2Delegate> {
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary *countryLocation = [self.allSelections objectAtIndex:indexPath.section];
//    NSArray *locations = [countryLocation objectForKey:@"cities"];
//    NSDictionary *selection = [locations objectAtIndex:indexPath.row];
    NSDictionary *selection = [self.allSelections objectAtIndex:indexPath.row];
    if (!self.requiresStep2) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectionDidSelect:)]) {
            [self.delegate selectionDidSelect:selection];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (indexPath.row == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectionDidSelect:)]) {
                [self.delegate selectionDidSelect:selection];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
            [[WebServiceManager sharedInstance] getCitiesFromCountry:[NSNumber numberWithInteger:[selection[@"id"] integerValue]] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                SelectionStep2ViewController *selectionStep2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionStep2ViewControllerIdentifier"];
                selectionStep2.countryName = selection[@"name"];

                selectionStep2.allSelections = [NSMutableArray arrayWithArray:dictionary[@"cities"]];
                selectionStep2.delegate = self;
                //            locationsCities.countryName = countryLocation[@"name"];
                [self.navigationController pushViewController:selectionStep2 animated:YES];
            }];
        }
    }
}

- (void)selectionStep2DidSelect:(NSDictionary *)selection {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectionDidSelect:)]) {
        [self.delegate selectionDidSelect:selection];
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.allSelections.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [[[self.allSelections objectAtIndex:section] objectForKey:@"cities"] count];
    return [self.allSelections count];
}

@end

