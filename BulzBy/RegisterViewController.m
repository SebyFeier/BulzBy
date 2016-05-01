//
//  RegisterViewController.m
//  BulzBy
//
//  Created by Seby Feier on 18/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebServiceManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
#import "HexColors.h"
#import "Haneke.h"
#import "UIView+Borders.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UITextField *registerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *registerEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerAgreeButton;
@property (weak, nonatomic) IBOutlet UITextField *registerConfirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *forgotView;
@property (weak, nonatomic) IBOutlet UITextField *forgotEmailTextField;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *profileUsernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *profileEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *profilePasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *profileConfirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *agreeSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editWidthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *editScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;
@property (weak, nonatomic) IBOutlet UITextField *registerPhoneTextField;
@end


@implementation RegisterViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIColor *grayColor = [UIColor hx_colorWithHexString:@"BFBFBF"];

    [self.registerNameTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerEmailTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerPasswordTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerConfirmPasswordTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerPhoneTextField addBottomBorderWithHeight:1 andColor:grayColor];
    
    
    [self.forgotEmailTextField addBottomBorderWithHeight:1 andColor:grayColor];

}
- (IBAction)agreeSwitchTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    UIColor *grayColor = [UIColor hx_colorWithHexString:@"BFBFBF"];
    
    [self.registerNameTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerEmailTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerPasswordTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerConfirmPasswordTextField addBottomBorderWithHeight:1 andColor:grayColor];
    [self.registerPhoneTextField addBottomBorderWithHeight:1 andColor:grayColor];
    
    
    [self.forgotEmailTextField addBottomBorderWithHeight:1 andColor:grayColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == REGISTER) {
        self.registerView.hidden = NO;
        self.forgotView.hidden = YES;
        self.editView.hidden = YES;
        self.navigationTitle.text = NSLocalizedString(@"Register", nil);
//        self.navigationItem.title = @"Inregistrare";
    } else if (self.type == FORGOT) {
        self.registerView.hidden = YES;
        self.forgotView.hidden = NO;
        self.editView.hidden = YES;
//        self.navigationItem.title = @"Resetare Parolă";
        self.navigationTitle.text = NSLocalizedString(@"Reset Password", nil);
    } else if (self.type == EDIT) {
        self.registerView.hidden = YES;
        self.forgotView.hidden = YES;
        self.editView.hidden = NO;
//        self.navigationItem.title = @"Profilul meu";
        self.navigationTitle.text = NSLocalizedString(@"My Profile", nil);
        self.editWidthConstraint.constant = CGRectGetWidth(self.view.frame) - 40;
        [self.view layoutIfNeeded];
        if (self.userInfo) {
            self.profileUsernameLabel.text = self.userInfo[@"name"];
            self.profileEmailLabel.text = self.userInfo[@"email"];
            if ([self.userInfo[@"post_avatar"] length]) {
                [self.profileImageView hnk_setImageFromURL:[NSURL URLWithString:self.userInfo[@"post_avatar"]]];
            } else {
                [self.profileImageView setImage:[UIImage imageNamed:@"no_avatar"]];
            }
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.registerAgreeButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
    
    NSString *agreeTermsText = NSLocalizedString(@"I agree with Terms and Conditions...", nil);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:agreeTermsText];
    NSRange range=[agreeTermsText rangeOfString:NSLocalizedString(@"Terms and Conditions...", nil)];
    
    UIFont *font = [UIFont boldSystemFontOfSize:11];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    [attrString addAttributes:attrsDictionary range:range];
    [self.registerAgreeButton.titleLabel setTextColor:[UIColor blackColor]];
    [self.registerAgreeButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
    UIColor *color = [UIColor hx_colorWithHexString:@"000000"];
    self.profileUsernameLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Username", nil) attributes:@{NSForegroundColorAttributeName:color}];
    self.profileEmailLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"E-mail", nil) attributes:@{NSForegroundColorAttributeName:color}];
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.profileUsernameLabel.leftView = usernamePaddingView;
    self.profileUsernameLabel.leftViewMode = UITextFieldViewModeAlways;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.profilePasswordLabel.leftView = passwordPaddingView;
    self.profilePasswordLabel.leftViewMode = UITextFieldViewModeAlways;
    UIView *confirmPasswordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.profileConfirmPasswordTextField.leftView = confirmPasswordPaddingView;
    self.profileConfirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.profileEmailLabel.leftView = emailPaddingView;
    self.profileEmailLabel.leftViewMode = UITextFieldViewModeAlways;
    
    self.profileImageView.layer.cornerRadius = 30.0f;
    [self.profileImageView layoutIfNeeded];
    self.agreeSwitch.on = NO;

}

- (IBAction)registerButtonTapped:(id)sender {
    [self.view endEditing:YES];
    if ([self validateUsername:self.registerNameTextField.text]) {
        if ([self validateEmail:self.registerEmailTextField.text]) {
            if ([self validatePassword:self.registerPasswordTextField.text]) {
                if ([self.registerPasswordTextField.text isEqualToString:self.registerConfirmPasswordTextField.text]) {
                    if ([self validateUsername:self.registerPhoneTextField.text]) {
                        if (self.agreeSwitch.isOn) {
                            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                            [[WebServiceManager sharedInstance] registerWithEmail:self.registerEmailTextField.text andPassword:self.registerPasswordTextField.text andUsername:self.registerNameTextField.text phoneNumber:self.registerPhoneTextField.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                                if (!error) {
                                    if (dictionary[@"failed"]) {
                                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:dictionary[@"failed"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                    } else {
                                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                        [userDefaults setObject:self.registerEmailTextField.text forKey:@"email"];
                                        [userDefaults setObject:self.registerPasswordTextField.text forKey:@"password"];
//                                        [userDefaults setObject:dictionary forKey:@"userInfo"];
                                        [userDefaults synchronize];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                } else {
                                    if (dictionary[@"errors"]) {
                                    } else {
                                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                    }
                                }
                            }];
                        } else {
                            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"You have to agree with the terms and conditions", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                    } else {
                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Insert phone number", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                } else {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Passwords don't match", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            } else {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Password too short", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } else {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Invalid email", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Insert username", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.bottomConstraint.constant = 50;
    [self.view layoutIfNeeded];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.bottomConstraint.constant = 170;
    [self.view layoutIfNeeded];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.registerNameTextField) {
        [self.registerEmailTextField becomeFirstResponder];
    } else if (textField == self.registerEmailTextField) {
        [self.registerPasswordTextField becomeFirstResponder];
    } else if (textField == self.registerPasswordTextField) {
        [self.registerConfirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.registerConfirmPasswordTextField) {
        [self.registerPhoneTextField becomeFirstResponder];
    } else if (textField == self.registerPhoneTextField) {
        [self registerButtonTapped:nil];
    } else if (textField == self.forgotEmailTextField) {
        [self forgotResetPasswordButtonTapped:nil];
    } else if (textField == self.profileUsernameLabel) {
        [self.profileEmailLabel becomeFirstResponder];
    } else if (textField == self.profileEmailLabel) {
        [self.profilePasswordLabel becomeFirstResponder];
    } else if (textField == self.profilePasswordLabel) {
        [self.profileConfirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.profileConfirmPasswordTextField) {
        [self editSaveButtonTapped:nil];
    }
    return YES;
}
- (IBAction)registerAgreeTermsButtonTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)forgotResetPasswordButtonTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)editSaveButtonTapped:(id)sender {
    [self.view endEditing:YES];
    if ([self.profileUsernameLabel.text length]) {
        if ([self.profilePasswordLabel.text length]) {
            if ([self.profilePasswordLabel.text isEqualToString:self.profileConfirmPasswordTextField.text]) {
                [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                NSString *apiToken = [[[WebServiceManager sharedInstance] userInfo] objectForKey:@"api_token"];
                [[WebServiceManager sharedInstance] editUserWithId:self.userInfo[@"id_user"] username:self.profileUsernameLabel.text andPassword:self.profilePasswordLabel.text andApiToken:apiToken andEmail:self.profileEmailLabel.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:self.profileEmailLabel.text forKey:@"email"];
                    [userDefaults setObject:self.profilePasswordLabel.text forKey:@"password"];
                    [userDefaults setObject:dictionary[@"id_user"] forKey:@"id_user"];
                    [userDefaults synchronize];
                    
                }];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Parolele nu coincid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } else {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
            NSString *apiToken = [[[WebServiceManager sharedInstance] userInfo] objectForKey:@"api_token"];
            [[WebServiceManager sharedInstance] editUserWithId:self.userInfo[@"id_user"] username:self.profileUsernameLabel.text andPassword:nil andApiToken:apiToken andEmail:self.profileEmailLabel.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:self.profileUsernameLabel.text forKey:@"email"];
                //                [userDefaults setObject:self.passwordTextField.text forKey:@"password"];
                [userDefaults setObject:dictionary[@"id_user"] forKey:@"id_user"];
                [userDefaults synchronize];
            }];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:@"Introduceți numele" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

-(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

- (BOOL)validatePassword:(NSString *)password {
    if (password.length >= 8) {
        return YES;
    }
    return NO;
}

- (BOOL)validateUsername:(NSString *)username {
    if (username.length > 0) {
        return YES;
    }
    return NO;
}
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
