//
//  ReviewViewController.m
//  BulzBy
//
//  Created by Seby Feier on 17/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewTableViewCell.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"

@interface ReviewViewController()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    BOOL toAddReview;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addReviewTopConstraint.constant = CGRectGetHeight(self.view.frame);
    [self.view layoutIfNeeded];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.foodRating.value = 0;
    self.foodRating.maximumValue =5;
    self.foodRating.minimumValue = 0;
    self.foodRating.spacing =3;
    self.foodRating.allowsHalfStars =YES;
    self.foodRating.accurateHalfStars =YES;
    self.foodRating.emptyStarImage = [UIImage imageNamed:@"rate_2"];
    self.foodRating.filledStarImage = [UIImage imageNamed:@"rate_1"];
    
    self.serviceRating.value = 0;
    self.serviceRating.maximumValue =5;
    self.serviceRating.minimumValue = 0;
    self.serviceRating.spacing =3;
    self.serviceRating.allowsHalfStars =YES;
    self.serviceRating.accurateHalfStars =YES;
    self.serviceRating.emptyStarImage = [UIImage imageNamed:@"rate_2"];
    self.serviceRating.filledStarImage = [UIImage imageNamed:@"rate_1"];
    
    self.environmentRating.value = 0;
    self.environmentRating.maximumValue =5;
    self.environmentRating.minimumValue = 0;
    self.environmentRating.spacing =3;
    self.environmentRating.allowsHalfStars =YES;
    self.environmentRating.accurateHalfStars =YES;
    self.environmentRating.emptyStarImage = [UIImage imageNamed:@"rate_2"];
    self.environmentRating.filledStarImage = [UIImage imageNamed:@"rate_1"];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonTapped:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"email"]) {
        self.environmentRating.value = 0;
        self.serviceRating.value = 0;
        self.foodRating.value = 0;
        self.environmentRating.enabled = YES;
        self.foodRating.enabled = YES;
        self.serviceRating.enabled = YES;
        self.reviewTextView.text = NSLocalizedString(@" Enter Review", nil);
        self.reviewTextView.editable = YES;
        self.submitButton.hidden = NO;
        self.submitLabel.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.addReviewTopConstraint.constant = 0;
            self.cancelLabelAlignment.constant = 40;
            self.cancelButtonAlignment.constant = 40;
            [self.view layoutIfNeeded];
        }];
    } else {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerIdentifier"];
        loginViewController.shouldReturn = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allReviews count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 77;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewTableViewCellIdentifier"];
    if (!cell) {
        cell = [[ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReviewTableViewCellIdentifier"];
    }
    NSDictionary *review = [self.allReviews objectAtIndex:indexPath.row];
    cell.reviewLabel.text = review[@"description"];
    cell.userLabel.text = [review[@"user"] objectForKey:@"name"];
    float Rate = 0;
    if (![review[@"star_environment"] isKindOfClass:[NSNull class]]) {
        float star_environment = [review[@"star_environment"] floatValue];
        if (![review[@"star_food"] isKindOfClass:[NSNull class]]) {
            float star_food = [review[@"star_food"] floatValue];
            if (![review[@"star_service"] isKindOfClass:[NSNull class]]) {
                float star_service = [review[@"star_service"] floatValue];
                Rate = (star_environment + star_food + star_service) / 3;
            } else {
                Rate = (star_environment + star_food) / 2;
            }
        } else {
            Rate = star_environment;
        }
    }
    cell.starRatingView.value = Rate;
    cell.starRatingView.maximumValue =5;
    cell.starRatingView.minimumValue = 0;
    cell.starRatingView.spacing =3;
    cell.starRatingView.allowsHalfStars =YES;
    cell.starRatingView.accurateHalfStars =YES;
    cell.starRatingView.emptyStarImage = [UIImage imageNamed:@"rate_2"];
    cell.starRatingView.filledStarImage = [UIImage imageNamed:@"rate_1"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *review = [self.allReviews objectAtIndex:indexPath.row];
    self.foodRating.enabled = NO;
    self.serviceRating.enabled = NO;
    self.environmentRating.enabled = NO;
    if (![review[@"star_environment"] isKindOfClass:[NSNull class]]) {
        self.environmentRating.value = [review[@"star_environment"] floatValue];
    } else {
        self.environmentRating.value = 0;
    }
    if (![review[@"star_food"] isKindOfClass:[NSNull class]]) {
        self.foodRating.value = [review[@"star_food"] floatValue];
    } else {
        self.foodRating.value = 0;
    }
    if (![review[@"star_service"] isKindOfClass:[NSNull class]]) {
        self.serviceRating.value = [review[@"star_service"] floatValue];
    } else {
        self.serviceRating.value = 0;
    }
    self.reviewTextView.text = review[@"description"];
    self.reviewTextView.editable = NO;
    self.submitLabel.hidden = YES;
    self.submitButton.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.addReviewTopConstraint.constant = 0;
        self.cancelLabelAlignment.constant = 0;
        self.cancelButtonAlignment.constant = 0;
        [self.view layoutIfNeeded];
    }];
}
- (IBAction)submitButtonTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] reviewCompanyWithApiToken:[[[WebServiceManager sharedInstance] userInfo] objectForKey:@"api_token"] withCompanyId:self.restaurantInfo[@"id"] description:self.reviewTextView.text starFood:[NSNumber numberWithFloat:self.foodRating.value] starService:[NSNumber numberWithFloat:self.serviceRating.value] starEnvironment:[NSNumber numberWithFloat:self.environmentRating.value] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        NSLog(@"%@",dictionary);
        if (!error) {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
            [[WebServiceManager sharedInstance] getCompanyInformationWithId:self.restaurantInfo[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                if (!error) {
                    self.allReviews = dictionary[@"reviews"];
                    [self.tableView reloadData];
                }
            }];
        } else {
            if (dictionary[@"errors"]) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[dictionary[@"errors"] firstObject] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.foodRating.value = 0;
            self.serviceRating.value = 0;
            self.environmentRating.value = 0;
            self.addReviewTopConstraint.constant = CGRectGetHeight(self.view.frame);
            [self.view endEditing:YES];
            [self.view layoutIfNeeded];
        }];
    }];
}
- (IBAction)cancelButtonTapped:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        [self.view endEditing:YES];
        self.addReviewTopConstraint.constant = CGRectGetHeight(self.view.frame);
        [self.view layoutIfNeeded];
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:NSLocalizedString(@" Enter Review", nil)]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@" Enter Review", nil);
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


@end
