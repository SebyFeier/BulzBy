//
//  AttachementCollectionViewCell.m
//  BulzBy
//
//  Created by Seby Feier on 23/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "AttachementCollectionViewCell.h"
#import "Haneke.h"

@implementation AttachementCollectionViewCell {
    UIImageView *_imageView;
}

- (void)loadImageWithInfo:(NSDictionary *)imageInfo {
    if (!_imageView ) {
        _imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:_imageView];
        _imageView.frame = self.frame;
        [_imageView setBackgroundColor:[UIColor clearColor]];
        _imageView.image = nil;
    }
    NSDictionary *file = imageInfo[@"file"];
    NSDictionary *thumbImageInfo = file[@"thumb"];
    NSString *urlString = thumbImageInfo[@"url"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://restaurantfinder.boxnets.com%@",urlString]];
    [_imageView hnk_setImageFromURL:url];
}

- (void)layoutSubviews {
    [_imageView setFrame:self.bounds];
    [super layoutSubviews];
}

@end
