//
//  SelectionStep2ViewController.h
//  BulzBy
//
//  Created by Sebastian Feier on 5/12/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectionStep2Delegate <NSObject>

- (void)selectionStep2DidSelect:(NSDictionary *)selection;

@end

@interface SelectionStep2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allSelections;
@property (nonatomic, strong) id<SelectionStep2Delegate>delegate;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (nonatomic, strong) NSString *countryName;




@end
