//
//  ReviewViewController.h
//  BulzBy
//
//  Created by Seby Feier on 17/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface ReviewViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *allReviews;
@property (nonatomic, strong) NSDictionary *restaurantInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addReviewTopConstraint;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *foodRating;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *serviceRating;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *environmentRating;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;

@end
