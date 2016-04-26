//
//  BookingTableViewCell.h
//  BulzBy
//
//  Created by Seby Feier on 21/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *restaurantTable;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *bookingDateTime;

- (void)updateCellWithInfo:(NSDictionary *)cellInfo;

@end
