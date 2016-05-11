//
//  DetailsViewController.h
//  BulzBy
//
//  Created by Seby Feier on 16/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionViewHeight;

@property (nonatomic, strong) NSDictionary *restaurantInfo;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *descriptionTitle;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, strong) UICollectionView *galleryCollectionView;
@end