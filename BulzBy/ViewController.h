//
//  ViewController.h
//  BulzBy
//
//  Created by Seby Feier on 14/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableView.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *allRestaurants;
@property (nonatomic, strong) NSMutableArray *allCategories;
@property (nonatomic, strong) NSMutableArray *allCountries;
@property (nonatomic, strong) MenuTableView *menuTableView;


@end

