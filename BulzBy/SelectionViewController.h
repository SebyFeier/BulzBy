//
//  SelectionViewController.h
//  BulzBy
//
//  Created by Seby Feier on 19/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionDelegate <NSObject>

- (void)selectionDidSelect:(NSDictionary *)selection;

@end

@interface SelectionViewController : UIViewController

@property (nonatomic, strong) NSArray *allSelections;
@property (nonatomic, weak) id<SelectionDelegate>delegate;

@end

