//
//  BookingTableViewCell.m
//  BulzBy
//
//  Created by Seby Feier on 21/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "BookingTableViewCell.h"

@implementation BookingTableViewCell

- (void)updateCellWithInfo:(NSDictionary *)cellInfo {
    self.restaurantTable.text = [cellInfo[@"company"] objectForKey:@"name"];
    self.restaurantAddress.text = [cellInfo[@"location"] objectForKey:@"address"];
    self.bookingDateTime.text = cellInfo[@"datetime"];
    
}

@end
