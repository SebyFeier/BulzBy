//
//  MenuTableViewCell.h
//  BulzBy
//
//  Created by Seby Feier on 14/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UILabel *categoryNameLabel;

- (void)updateCellWithInfo:(NSDictionary *)cellInfo;
- (void)uppdateCellWithInfo:(NSDictionary *)cellInfo withImage:(NSString *)imageName;

@end
