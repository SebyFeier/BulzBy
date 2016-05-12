//
//  HomeTableViewCell.m
//  BulzBy
//
//  Created by Seby Feier on 14/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "Haneke.h"
#import "HCSStarRatingView.h"

@interface HomeTableViewCell() {
    
}


@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantTitle;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLocation;
@property (weak, nonatomic) IBOutlet UILabel *restaurantWebSite;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;
@end

@implementation HomeTableViewCell

- (void)updateCellWithInfo:(NSDictionary *)cellInfo {
    self.restaurantTitle.text = cellInfo[@"name"];
    if ([cellInfo[@"phone"] length]) {
        self.restaurantLocation.text = cellInfo[@"phone"];
    } else {
        self.restaurantLocation.text = @"";
    }
    NSDictionary *avatar = cellInfo[@"avatar"];
    if (avatar) {
        if (avatar[@"thumb"] && avatar[@"thumb"] && [avatar[@"thumb"] objectForKey:@"url"]) {
            [self.restaurantImageView hnk_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://restaurantfinder.boxnets.com%@", [avatar[@"thumb"] objectForKey:@"url"]]]];
        }
    }
//    NSArray *locations = cellInfo[@"locations"];
//    if (locations) {
//        NSDictionary *location = [locations firstObject];
//        self.restaurantLocation.text = cellInfo[@"phone"];
//    } else {
//        self.restaurantLocation.text = @"";
//    }
    float Rate = 0;
    if (![cellInfo[@"average_rating"] isKindOfClass:[NSNull class]]) {
        Rate = [cellInfo[@"average_rating"] floatValue];
    }
//    float Rate = 4;
    
    self.starRatingView.value = Rate;
    self.starRatingView.maximumValue =5;
    self.starRatingView.minimumValue = 0;
    self.starRatingView.spacing =3;
    self.starRatingView.allowsHalfStars =YES;
    self.starRatingView.accurateHalfStars =YES;
    self.starRatingView.emptyStarImage = [UIImage imageNamed:@"rate_2"];
    self.starRatingView.filledStarImage = [UIImage imageNamed:@"rate_1"];
    
}

@end
