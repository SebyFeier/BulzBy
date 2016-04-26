//
//  RegisterViewController.h
//  BulzBy
//
//  Created by Seby Feier on 18/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    REGISTER = 1,
    FORGOT,
    EDIT
} TYPE;

@interface RegisterViewController : UIViewController

@property (nonatomic, assign) TYPE type;
@property (nonatomic, strong) NSDictionary *userInfo;

@end
