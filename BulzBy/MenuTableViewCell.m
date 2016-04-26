//
//  MenuTableViewCell.m
//  BulzBy
//
//  Created by Seby Feier on 14/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "Haneke.h"

@implementation MenuTableViewCell

- (void)updateCellWithInfo:(NSDictionary *)cellInfo {
    if (!self.categoryImageView) {
        self.categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 22, 22)];
        self.categoryImageView.center = CGPointMake(self.categoryImageView.center.x, CGRectGetHeight(self.frame) / 2);
        [self addSubview:self.categoryImageView];
    }
    if (!self.categoryNameLabel) {
        self.categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.categoryImageView.frame) + 10, 0, CGRectGetWidth(self.frame) - 40, 44)];
        [self addSubview:self.categoryNameLabel];
    }
//    NSDictionary *category = [self.allCategories objectAtIndex:indexPath.row];
    self.categoryNameLabel.text = cellInfo[@"name"];
    self.categoryNameLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    NSDictionary *avatar = cellInfo[@"icon"];
    if (avatar) {
        if (avatar[@"thumb"] && avatar[@"thumb"] && [avatar[@"thumb"] objectForKey:@"url"]) {
//            [self.categoryImageView setImage:[UIImage imageNamed:@"menu.png"]];
            [self.categoryImageView hnk_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://restaurantfinder.boxnets.com%@",[avatar[@"thumb"] objectForKey:@"url"]]]];
        }
    }

    
}
- (void)uppdateCellWithInfo:(NSDictionary *)cellInfo withImage:(NSString *)imageName {
    if (!self.categoryImageView) {
        self.categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 22, 22)];
        self.categoryImageView.center = CGPointMake(self.categoryImageView.center.x, CGRectGetHeight(self.frame) / 2);
        [self addSubview:self.categoryImageView];
    }
    if (!self.categoryNameLabel) {
        self.categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.categoryImageView.frame) + 10, 0, CGRectGetWidth(self.frame) - 40, 44)];
        [self addSubview:self.categoryNameLabel];
    }
    //    NSDictionary *category = [self.allCategories objectAtIndex:indexPath.row];
    self.categoryNameLabel.text = cellInfo[@"name"];
    self.categoryNameLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    [self.categoryImageView setImage:[UIImage imageNamed:imageName]];
    self.categoryImageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
