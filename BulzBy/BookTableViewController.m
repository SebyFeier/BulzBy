//
//  BookTableViewController.m
//  BulzBy
//
//  Created by Seby Feier on 18/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "BookTableViewController.h"
#import "UIView+Borders.h"
#import "SelectionViewController.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"

@interface BookTableViewController()<UITextViewDelegate, SelectionDelegate> {
    NSDictionary *selectedLocation;
    UIToolbar *doneDateToolbar_;
    UIToolbar *doneTimeToolbar_;
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
}

@property (weak, nonatomic) IBOutlet UILabel *dateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateError;
@property (weak, nonatomic) IBOutlet UIImageView *timeError;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;


@end

@implementation BookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateError.hidden = YES;
    self.timeError.hidden = YES;
    [self.locationButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.locationButton addTopBorderWithHeight:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addLeftBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addRightBorderWithWidth:0.5 andColor:[UIColor whiteColor]];
    [self.locationButton addBottomBorderWithHeight:0.5 andColor:[UIColor whiteColor]];

}

- (IBAction)backButtonTapped:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)bookNowButtonTapped:(id)sender {
//    if ([self.dateLabel.text isEqualToString:@""] || [self.timeLabel.text isEqualToString:@""]) {
        BOOL isDate = [self validationCheckForDate];
        BOOL isTime = [self validationCheckForTime];
//    }
//    NSArray *dateArray = [self.dateLabel.text componentsSeparatedByString:@"/"];
//    NSArray *timeArray = [self.timeLabel.text componentsSeparatedByString:@":"];
//    NSString *dateTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@", dateArray[0], dateArray[1], dateArray[2], timeArray[0], timeArray[1]];
    if (isDate && isTime) {
        NSString *dateTime = [NSString stringWithFormat:@"%@ %@",self.dateLabel.text, self.timeLabel.text];
        NSString *apiToken = [[[WebServiceManager sharedInstance] userInfo] objectForKey:@"api_token"];
        if (!apiToken) {
            apiToken = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"api_token"];
        }
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] bookLocationForApiToken:apiToken locationIdid:selectedLocation[@"id"] description:self.commentsTextView.text dateTime:dateTime withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}

- (void)createDateToolbar {
    
    if (!doneDateToolbar_) {
        doneDateToolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 250, CGRectGetWidth(self.view.frame), 44)];
        [doneDateToolbar_ insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_40.png"]] atIndex:0];
        [doneDateToolbar_ setTintColor:[UIColor blackColor]];
        UIBarButtonItem *barButtonFlexibleGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                          target:self
                                          action:@selector(toolBarSelectedDateDone:)];
        doneDateToolbar_.items = [NSArray arrayWithObjects:barButtonFlexibleGap,barButtonDone, nil];
        [self.view addSubview:doneDateToolbar_];
    }
}

- (void)createTimeToolbar {
    if (!doneTimeToolbar_) {
        doneTimeToolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 250, CGRectGetWidth(self.view.frame), 44)];
        [doneTimeToolbar_ insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_40.png"]] atIndex:0];
        [doneTimeToolbar_ setTintColor:[UIColor blackColor]];
        UIBarButtonItem *barButtonFlexibleGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                          target:self
                                          action:@selector(toolBarSelectedTimeDone:)];
        doneTimeToolbar_.items = [NSArray arrayWithObjects:barButtonFlexibleGap,barButtonDone, nil];
        [self.view addSubview:doneTimeToolbar_];
    }
}

- (void)toolBarSelectedDateDone:(id)sender {
    NSDateFormatter __autoreleasing *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
//    dateFormat.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString =  [dateFormat stringFromDate:datePicker.date];
    self.dateLabel.text = dateString;
    [doneDateToolbar_ removeFromSuperview];
    doneDateToolbar_ = nil;
    [datePicker removeFromSuperview];
    datePicker = nil;
    self.dateError.hidden = YES;
}


- (void)toolBarSelectedTimeDone:(id)sender {
    NSDateFormatter __autoreleasing *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"hh:mm"];
    //    dateFormat.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString =  [dateFormat stringFromDate:timePicker.date];
    self.timeLabel.text = dateString;
    [doneTimeToolbar_ removeFromSuperview];
    doneTimeToolbar_ = nil;
    [timePicker removeFromSuperview];
    timePicker = nil;
    self.timeError.hidden = YES;
}

//- (void)startDateSelected:(id)sender {
//    
//}
- (IBAction)dateButtonTapped:(id)sender {
    [self.view endEditing:YES];
    datePicker   = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 216, CGRectGetWidth(self.view.frame), 216)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    datePicker.backgroundColor = [UIColor whiteColor];
//    [datePicker addTarget:self action:@selector(startDateSelected:) forControlEvents:UIControlEventValueChanged];
    [self createDateToolbar];
//    [picker1 insertSubview:doneToolbar_ atIndex:0];
    [self.view addSubview:datePicker];

}
- (IBAction)timeButtonTapped:(id)sender {
    [self.view endEditing:YES];
    
     timePicker  = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 216, CGRectGetWidth(self.view.frame), 216)];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    timePicker.backgroundColor = [UIColor whiteColor];
//    [timePicker addTarget:self action:@selector(startTimeSelected:) forControlEvents:UIControlEventValueChanged];
    [self createTimeToolbar];
    //    [picker1 insertSubview:doneToolbar_ atIndex:0];
    [self.view addSubview:timePicker];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.commentsTextView.text isEqualToString:NSLocalizedString(@"Comments", nil)]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"Comments", nil);
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(BOOL)validationCheckForDate
{
    if ([self.dateLabel.text isEqualToString:@""])
    {
        self.dateError.hidden=NO;
        return NO;
    }
    else
    {
        self.dateError.hidden=YES;
        return YES;
    }
}

// Validation For Time
-(BOOL)validationCheckForTime
{
    if ([self.timeLabel.text isEqualToString:@""])
    {
        self.timeError.hidden=NO;
        return NO;
    }
    else
    {
        self.timeError.hidden=YES;
        return YES;
    }
}

- (IBAction)locationButtonTapped:(id)sender {
    [self.view endEditing:YES];
    SelectionViewController *selectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionViewControllerIdentifier"];
//    selectionViewController.allSelections = [[NSUserDefaults standardUserDefaults] objectForKey:@"allCountries"];
    selectionViewController.allSelections = self.restaurantInfo[@"locations"];
    selectionViewController.delegate = self;
    [self.navigationController pushViewController:selectionViewController animated:YES];
}

- (void)selectionDidSelect:(NSDictionary *)selection {
        selectedLocation = selection;
        [self.locationButton setTitle:selection[@"name"] forState:UIControlStateNormal];
}

@end
