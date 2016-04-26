//
//  BookingsViewController.h
//  BulzBy
//
//  Created by Seby Feier on 21/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *myBookings;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
