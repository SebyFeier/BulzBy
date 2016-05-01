//
//  EmailViewController.m
//  BulzBy
//
//  Created by Seby Feier on 29/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "EmailViewController.h"
#import "HexColors.h"
#import "UIView+Borders.h"
#import "MBProgressHUD.h"
#import "WebServiceManager.h"

@interface EmailViewController ()<UITextViewDelegate, UITextFieldDelegate> {
    NSString *textViewInitialMessage;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailButton;

@end

@implementation EmailViewController
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.emailTextField.delegate = self;
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.emailTextField.leftView = usernamePaddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.nameTextField.leftView = passwordPaddingView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *phonePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.phoneTextField.leftView = phonePaddingView;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIColor *color = [UIColor hx_colorWithHexString:@"BFBFBF"];
    //    self.messageTextView.textColor = color;
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Username", nil) attributes:@{NSForegroundColorAttributeName:color}];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"E-mail", nil) attributes:@{NSForegroundColorAttributeName:color}];
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Phone", nil) attributes:@{NSForegroundColorAttributeName:color}];
    self.messageTextView.textColor = [UIColor hx_colorWithHexString:@"BFBFBF"];
    
    textViewInitialMessage = NSLocalizedString(@"Your Message", nil);
    [self.sendEmailButton setTitle:NSLocalizedString(@"Send message", nil) forState:UIControlStateNormal];
    self.messageTextView.text = textViewInitialMessage;
    [self.nameTextField addBottomBorderWithHeight:1 andColor:color];
    [self.emailTextField addBottomBorderWithHeight:1 andColor:color];
    [self.phoneTextField addBottomBorderWithHeight:1 andColor:color];


    // Do any additional setup after loading the view.
}
- (IBAction)sendEmailButtonTapped:(id)sender {
    [self.view endEditing:YES];
    if (self.nameTextField.text.length > 0) {
        if ([self validateEmail:self.emailTextField.text]) {
            if (self.phoneTextField.text.length > 0) {
                [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                [[WebServiceManager sharedInstance] contactOwnerWithUsername:self.nameTextField.text email:self.emailTextField.text phone:self.phoneTextField.text message:self.messageTextView.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                    if (!error) {
//                        if ([dictionary[@"success"] boolValue]) {
                            [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"You will be contacted soon", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            [self.navigationController popViewControllerAnimated:YES];
//                        }
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                }];
            } else {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please insert your phone number", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } else {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please insert your email", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Please insert your username", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
//    if ([self validateEmail:self.emailTextField.text]) {
////                    if ([self validateEmail:self.emailTextField.text]) {
//        if ([self.messageTextView.text length]) {
//            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//            [[WebServiceManager sharedInstance] contactOwnerWithEmail:self.emailTextField.text phoneNumber:self.nameTextField.text body:self.messageTextView.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
//                [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//                if (!error) {
//                    if ([dictionary[@"success"] boolValue]) {
//                        [[[UIAlertView alloc] initWithTitle:@"" message:@"Veți fi contactat in curand" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }
//                } else {
//                    [[[UIAlertView alloc] initWithTitle:@"Eroare" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                }
//                
//            }];
//        } else {
//            [[[UIAlertView alloc] initWithTitle:@"" message:@"Introduceți mesajul" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        }
//    } else {
//        [[[UIAlertView alloc] initWithTitle:@"" message:@"Introduceți emailul" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.phoneTextField becomeFirstResponder];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewInitialMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = textViewInitialMessage;
        textView.textColor = [UIColor hx_colorWithHexString:@"BFBFBF"]; //optional
    }
    [textView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
