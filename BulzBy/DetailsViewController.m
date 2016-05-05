//
//  DetailsViewController.m
//  BulzBy
//
//  Created by Seby Feier on 16/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "DetailsViewController.h"
#import "Haneke.h"
#import "MapViewController.h"
#import "ReviewViewController.h"
#import "BookTableViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"
#import "UILabel+Image.h"
#import "AttachementCollectionViewCell.h"
#import "PhotoGalleryViewController.h"

@interface DetailsViewController()<UIScrollViewDelegate> {
    NSArray *imagesArray;
    CGFloat nextHeight;
    CGFloat infoTotalHeight;
    CGFloat scheduleHeight;
}

@end

@implementation DetailsViewController

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self createInterface];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createInterface];
}

- (void)createInterface {
    
    self.scrollViewWidth.constant = CGRectGetWidth(self.view.frame);
    [self.view layoutIfNeeded];
    
    for (int i = 0; i < [imagesArray count]; i++)
    {
        CGFloat xOrigin = i * self.imageScrollView.frame.size.width;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, -20, self.scrollViewWidth.constant, self.imageScrollView.frame.size.height + 20)];
        //        [imageView setImage:[UIImage imageNamed:[imagesArray objectAtIndex:i]]];
        [imageView hnk_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://restaurantfinder.boxnets.com%@",[imagesArray objectAtIndex:i]]]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self.imageScrollView addSubview:imageView];
    }
    
    if ([self.restaurantInfo[@"description"] isKindOfClass:[NSNull class]] || ![self.restaurantInfo[@"description"] length]) {
        self.descriptionViewHeight.constant = 0;
        [self.descriptionView removeFromSuperview];
    } else {
        self.descriptionLabel.text = self.restaurantInfo[@"description"];
        [self updateDescription];
    }
    
    
    nextHeight = 110;
    infoTotalHeight = 0;
    for (NSInteger locationIndex = 0; locationIndex < [self.restaurantInfo[@"locations"] count]; locationIndex++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (self.descriptionViewHeight.constant > 0)?CGRectGetMaxY(self.descriptionView.frame) + (nextHeight * locationIndex) + 10:CGRectGetMaxY(self.imageScrollView.frame) + (nextHeight * locationIndex) + 20, CGRectGetWidth(self.mainScrollView.frame), 140)];
        view.backgroundColor = [UIColor whiteColor];
        NSDictionary *location = [self.restaurantInfo[@"locations"] objectAtIndex:locationIndex];
        float currentHeight = 0;
        if ([location[@"name"] length]) {
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(view.frame) - 20, 20)];
            nameLabel.text = [NSString stringWithFormat:@"%@", location[@"name"]];
            nameLabel.font = [UIFont boldSystemFontOfSize:17];
            [view addSubview:nameLabel];
            currentHeight = 20;
        }
        if ([location[@"address"] length]) {
            UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight + 10, CGRectGetWidth(view.frame) - 20, 20)];
            addressLabel.numberOfLines = 0;
            addressLabel = [addressLabel createLabelWithImage:@"address_map_icon" andTitle:location[@"address"] isSquared:YES];
            CGRect descriptionFrame = addressLabel.frame;
            
            float descriptionHeight = [self getHeightForText:addressLabel.text
                                                    withFont:addressLabel.font
                                                    andWidth:addressLabel.frame.size.width];
            
            addressLabel.frame = CGRectMake(descriptionFrame.origin.x,
                                            descriptionFrame.origin.y,
                                            descriptionFrame.size.width,
                                            descriptionHeight);
            [view addSubview:addressLabel];
            [self.view layoutIfNeeded];
            currentHeight += descriptionHeight;
        }
        //
        if ([location[@"phone"] length]) {
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight+ 15, CGRectGetWidth(view.frame) - 20, 20)];
        phoneLabel = [phoneLabel createLabelWithImage:@"phone512" andTitle:location[@"phone"] isSquared:YES];
        [view addSubview:phoneLabel ];
            currentHeight += 20;
        }
        if ([location[@"email"] length]) {
            UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight + 15, CGRectGetWidth(view.frame) - 20, 20)];
            emailLabel = [emailLabel createLabelWithImage:@"mail512" andTitle:location[@"email"] isSquared:NO];
            [view addSubview:emailLabel];
            currentHeight += 20;
        }
//        if ([location[@"website"] length]) {
//        UILabel *scheduleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight + 15, CGRectGetWidth(view.frame) - 20, 20)];
//        scheduleLabel = [scheduleLabel createLabelWithImage:@"schedule512" andTitle:@"" isPortrait:NO];
//        [view addSubview:scheduleLabel];
//            currentHeight += 20;
//        }
        view.frame = CGRectMake(0, (self.descriptionViewHeight.constant > 0)?CGRectGetMaxY(self.descriptionView.frame) + (nextHeight * locationIndex) + 10:nextHeight * locationIndex + locationIndex>0?20:0, CGRectGetWidth(self.mainScrollView.frame), currentHeight + 40);
//        view.frame = CGRectMake(0, (self.descriptionViewHeight.constant > 0)?CGRectGetMaxY(self.descriptionView.frame) + (nextHeight * locationIndex) + 10:CGRectGetMaxY(self.imageScrollView.frame) + (nextHeight * locationIndex) + 20, CGRectGetWidth(self.mainScrollView.frame), CGRectGetHeight(nameLabel.frame) + CGRectGetHeight(addressLabel.frame) + CGRectGetHeight(phoneLabel.frame) + CGRectGetHeight(emailLabel.frame) + CGRectGetHeight(scheduleLabel.frame) + 40);
        nextHeight = CGRectGetHeight(view.frame) + 10;
        infoTotalHeight += nextHeight;
        [self.mainScrollView addSubview:view];
    }
    [self.mainScrollView bringSubviewToFront:self.backButton];
    if ([self.restaurantInfo[@"schedule_display"] count] > 0) {
        scheduleHeight = 0;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.descriptionViewHeight.constant + infoTotalHeight + 10, CGRectGetWidth(self.mainScrollView.frame), scheduleHeight)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(view.frame) - 20, 20)];
//        nameLabel.text = [NSString stringWithFormat:@"%@", location[@"name"]];
        nameLabel.text = NSLocalizedString(@"Schedule", nil);
        nameLabel.font = [UIFont boldSystemFontOfSize:17];
        [view addSubview:nameLabel];
        scheduleHeight += 20;
        for (NSDictionary *schedule in self.restaurantInfo[@"schedule_display"]) {
            NSString *dayString;
            NSInteger day = [schedule[@"day"] integerValue];
            switch (day) {
                case 1:
                    dayString = NSLocalizedString(@"Monday", nil);
                    break;
                case 2:
                    dayString = NSLocalizedString(@"Tuesday", nil);
                    break;
                case 3:
                    dayString = NSLocalizedString(@"Wednesday", nil);
                    break;
                case 4:
                    dayString = NSLocalizedString(@"Thursday", nil);
                    break;
                case 5:
                    dayString = NSLocalizedString(@"Friday", nil);
                    break;
                case 6:
                    dayString = NSLocalizedString(@"Saturday", nil);
                    break;
                case 0:
                    dayString = NSLocalizedString(@"Sunday", nil);
                    break;
                default:
                    break;
            }
            UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, scheduleHeight + 20, 120, 20)];
            dayLabel = [dayLabel createLabelWithImage:@"schedule512" andTitle:[NSString stringWithFormat:@"%@:", dayString] isSquared:YES];
            [view addSubview:dayLabel];
            UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, scheduleHeight + 22, CGRectGetWidth(self.view.frame) - 130, 20)];
            hourLabel.text = schedule[@"hours"];
            [view addSubview:hourLabel];
            scheduleHeight += 20;

        }
        view.frame = CGRectMake(0, self.descriptionViewHeight.constant + infoTotalHeight + 10, CGRectGetWidth(self.mainScrollView.frame), scheduleHeight + 30);
        
        
        [self.mainScrollView addSubview:view];
    }
    
    
    if (!self.galleryCollectionView) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        self.galleryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.galleryCollectionView.pagingEnabled = YES;
        [self.galleryCollectionView setDataSource:self];
        [self.galleryCollectionView setDelegate:self];
        
        //            [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [self.galleryCollectionView setBackgroundColor:[UIColor clearColor]];
        [self.galleryCollectionView registerClass:[AttachementCollectionViewCell class] forCellWithReuseIdentifier:@"AttachementCollectionViewCellIdentifier"];
        CGFloat collectionViewHeight = 0;
        if ([self.restaurantInfo[@"attachments"] count] == 0) {
            collectionViewHeight = 0;
        } else if ([self.restaurantInfo[@"attachments"] count] <= 4) {
            collectionViewHeight = CGRectGetWidth(self.mainScrollView.frame) / 4;
        } else {
            collectionViewHeight = CGRectGetWidth(self.mainScrollView.frame) / 4 * 2;
        }
        if (collectionViewHeight > 0) {
            self.imagesView = [[UIView alloc] initWithFrame:CGRectZero];
            self.imagesView.backgroundColor = [UIColor whiteColor];
//            self.imagesView.frame = CGRectMake(0, CGRectGetHeight(self.imageScrollView.frame) + self.descriptionViewHeight.constant + infoTotalHeight + 25, CGRectGetWidth(self.mainScrollView.frame), collectionViewHeight + 45);
            self.imagesView.frame = CGRectMake(0, CGRectGetHeight(self.imageScrollView.frame) + self.descriptionViewHeight.constant + scheduleHeight + 75, CGRectGetWidth(self.mainScrollView.frame), collectionViewHeight + 45);
        }
        if (self.imagesView) {
            UILabel *photosLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.imagesView.frame) - 20, 20)];
            photosLabel.text = @"Photos";
            photosLabel.font = [UIFont boldSystemFontOfSize:17];
            
            [self.imagesView addSubview:photosLabel];
        self.galleryCollectionView.frame = CGRectMake(10, CGRectGetMaxY(photosLabel.frame) + 5, CGRectGetWidth(self.imagesView.frame) - 20, collectionViewHeight);
            
            [self.imagesView addSubview:self.galleryCollectionView];
        }
//        [self.mainScrollView addSubview:self.galleryCollectionView];
        [self.mainScrollView addSubview:self.imagesView];
        
    }
    
    
    
    self.mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.mainScrollView.frame),self.descriptionViewHeight.constant + infoTotalHeight + CGRectGetHeight(self.imagesView.frame) + scheduleHeight + 50);
    
    nextHeight = 0;

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageScrollView.delegate = self;
//    imagesArray = [NSArray arrayWithArray:self.restaurantInfo[@"avatar"]];
    imagesArray = [NSArray arrayWithObjects:[self.restaurantInfo[@"cover"]  objectForKey:@"url"], nil];
    self.restaurantNameLabel.text = self.restaurantInfo[@"name"];
    self.pageControl.numberOfPages = imagesArray.count;
    self.imageScrollView.userInteractionEnabled = NO;
    self.pageControl.hidden = YES;
    [self.imageScrollView setContentSize:CGSizeMake(self.view.frame.size.width * [imagesArray count], 126)];
    self.descriptionLabel.textAlignment = NSTextAlignmentJustified;
}


- (void)updateDescription {
    CGRect descriptionFrame = self.descriptionLabel.frame;
    
    float descriptionHeight = [self getHeightForText:self.descriptionLabel.text
                                            withFont:self.descriptionLabel.font
                                            andWidth:self.descriptionLabel.frame.size.width];
    
    self.descriptionLabel.frame = CGRectMake(descriptionFrame.origin.x,
                                             descriptionFrame.origin.y,
                                             descriptionFrame.size.width,
                                             descriptionHeight);
    self.descriptionViewHeight.constant = descriptionHeight + 80;
    [self.view layoutIfNeeded];
}

-(CGFloat) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    float totalHeight;
    
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    } else {
        //        title_size = [text sizeWithFont:font
        //                      constrainedToSize:constraint
        //                          lineBreakMode:NSLineBreakByWordWrapping];
        CGRect rect = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
        totalHeight = rect.size.height ;
    }
    
    CGFloat height = MAX(totalHeight, 40.0f);
    return height;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.imageScrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.imageScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)favoriteButtonTapped:(id)sender {
}

- (IBAction)phoneButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.restaurantInfo[@"phone"]]]];
}

- (IBAction)locationButtonTapped:(id)sender {
    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewControllerIdentifier"];
    NSMutableArray *allLocations = [[NSMutableArray alloc] initWithArray:self.restaurantInfo[@"locations"]];
    mapViewController.allLocations = allLocations;
    mapViewController.isRoute = YES;
    [self.navigationController pushViewController:mapViewController animated:YES];
    
}

- (IBAction)tableButtonTapped:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"email"]) {
        BookTableViewController *bookTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BookTableViewControllerIdentifier"];
        bookTableViewController.restaurantInfo = self.restaurantInfo;
        //    [self presentViewController:bookTableViewController animated:YES completion:nil];
        [self.navigationController pushViewController:bookTableViewController animated:YES];
    } else {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerIdentifier"];
        loginViewController.shouldReturn = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (IBAction)shareButtonTapped:(id)sender {
    NSString *textToShare = @"";
//    NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"https://anuntul.co.uk/%@.html",self.restaurantInfo[@"website"]]];
    NSURL *myWebsite = [NSURL URLWithString:self.restaurantInfo[@"website"]];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypePostToTwitter,
                                   UIActivityTypePostToTencentWeibo,
                                   UIActivityTypeOpenInIBooks];
    
    activityVC.excludedActivityTypes = excludeActivities;
    if ( [activityVC respondsToSelector:@selector(popoverPresentationController)] ) {
        // iOS8
        activityVC.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)reviewButtonTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//    NSDictionary *restaurantInfo = [self.allRestaurants objectAtIndex:indexPath.row];
    [[WebServiceManager sharedInstance] getCompanyInformationWithId:self.restaurantInfo[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//        DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewControllerIdentifier"];
//        detailsViewController.restaurantInfo = dictionary;
//        [self.navigationController pushViewController:detailsViewController animated:YES];
        ReviewViewController *reviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewViewControllerIdentifier"];
        reviewViewController.allReviews = dictionary[@"reviews"];
        reviewViewController.restaurantInfo = dictionary;
        [self.navigationController pushViewController:reviewViewController animated:YES];

        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return [self.adDetails[@"images"] count];
    if ([self.restaurantInfo[@"attachments"] count] > 8) {
        return 8;
    }
    return [self.restaurantInfo[@"attachments"] count];
//    return 8;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AttachementCollectionViewCell *cell = (AttachementCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AttachementCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    if (!cell) {
        cell = (AttachementCollectionViewCell *)[[AttachementCollectionViewCell alloc] initWithFrame:self.galleryCollectionView.bounds];
    }
//    cell.backgroundColor = [UIColor greenColor];
//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    cell.backgroundColor = color;
    NSDictionary *attachmentInfo = [self.restaurantInfo[@"attachments"] objectAtIndex:indexPath.row];
    [cell loadImageWithInfo:attachmentInfo];

    if (indexPath.row == 7) {
//        cell.backgroundColor = [UIColor clearColor];
        UIView *morePhotosView = [[UIView alloc] initWithFrame:cell.bounds];
        morePhotosView.backgroundColor = [UIColor blackColor];
        morePhotosView.alpha = 0.7;
        UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height / 2);
        NSInteger numberOfImages = [self.restaurantInfo[@"attachments"] count];
        label.text = [NSString stringWithFormat:@"+%ld", numberOfImages - 8];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        [morePhotosView addSubview:label];
        [cell addSubview:morePhotosView];
        [cell bringSubviewToFront:morePhotosView];
    }
//    NSDictionary *image = [self.adDetails[@"images"] objectAtIndex:indexPath.row];
//    [cell loadImageWithInfo:image isFullScreen:NO];
//    self.pageControl.currentPage = indexPath.row;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *imagesArray = [self.adDetails objectForKey:@"images"];
    PhotoGalleryViewController *photoGalleryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoGalleryViewControllerIdentifier"];
    photoGalleryViewController.imagesArray = self.restaurantInfo[@"attachments"];
    [self.navigationController pushViewController:photoGalleryViewController animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size =  CGSizeMake(CGRectGetWidth(self.mainScrollView.frame) / 4, CGRectGetWidth(self.mainScrollView.frame) / 4);
    size.width -= 10;
    return size;
}

@end
