//
//  AppDelegate.m
//  BulzBy
//
//  Created by Seby Feier on 14/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "MBProgressHUD.h"
#import "WebServiceManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [application setStatusBarHidden:YES];
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"email"] && [userDefaults objectForKey:@"password"]) {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        [[WebServiceManager sharedInstance] loginWithEmail:[userDefaults objectForKey:@"email"]  andPassword:[userDefaults objectForKey:@"password"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            if (!error) {
                if (!dictionary[@"failed"]) {
//                    userInfo = dictionary;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:[userDefaults objectForKey:@"email"] forKey:@"email"];
                    [userDefaults setObject:[userDefaults objectForKey:@"password"] forKey:@"password"];
                    [userDefaults setObject:[userDefaults objectForKey:@"facebookName"] forKey:@"facebookName"];
                    [userDefaults setObject:[userDefaults objectForKey:@"id_user"] forKey:@"id_user"];
                    //                    [userDefaults setObject:[userDefaults objectForKey:@"userInfo"] forKey:@"userInfo"];
                    [userDefaults synchronize];
                    //                    self.accountUsernameTextField.text = dictionary[@"nume"];
                    //                    self.accountTelephoneTextField.text = dictionary[@"telefon"];
                    //                    self.accountPasswordTextField.text = @"";
                    //                    self.accountConfirmPasswordTextField.text = @"";
                    //                    self.usernameLabel.text = dictionary[@"nume"];
                    //
                    //                    if (dictionary[@"avatar"] && ![dictionary[@"avatar"] isEqual:[NSNull null]]) {
                    //                        [self.userImageView hnk_setImageFromURL:[NSURL URLWithString:dictionary[@"avatar"]]];
                    //                    } else {
                    //                        [self.userImageView setImage:[UIImage imageNamed:@"no-image"]];
                    //                    }
                    //
                    //                    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                    //                    NSString *registeredDateString = dictionary[@"data_inreg"];
                    //                    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                    //                    NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                    //
                    //                    [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                    //                    NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                    //                    self.registeredLabel.text = [NSString stringWithFormat:@"Inregistrat pe %@",newDateString];
                    //                    if ([dictionary objectForKey:@"ultima_logare"] && ![[dictionary objectForKey:@"ultima_logare"] isEqual:[NSNull null]]) {
                    //
                    //                        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
                    //                        NSString *registeredDateString = [dictionary objectForKey:@"ultima_logare"];
                    //                        [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
                    //                        NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
                    //
                    //                        [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                    //                        NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
                    //                        self.onlineLabel.text = [NSString stringWithFormat:@"Online pe %@", newDateString];
                    //                    }
                } else {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:dictionary[@"failed"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            } else {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
        
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
