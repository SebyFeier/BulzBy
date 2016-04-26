//
//  LocationRestaurantsViewController.h
//  BulzBy
//
//  Created by Seby Feier on 19/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationRestaurantsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSInteger _pageNumber;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allRestaurants;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityId;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLabel;

@end
