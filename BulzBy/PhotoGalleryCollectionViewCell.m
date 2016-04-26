//
//  PhotoGalleryCollectionViewCell.m
//  BulzBy
//
//  Created by Seby Feier on 23/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "PhotoGalleryCollectionViewCell.h"
#import "Haneke.h"

@implementation PhotoGalleryCollectionViewCell {
    UIImageView *_imageView;
    //    UIScrollView *_scrollView;
}

- (void)loadImageWithInfo:(NSDictionary *)imageInfo {
    if (!_imageView ) {
        _imageView = [[UIImageView alloc] initWithFrame:self.frame];
//        if (isFullScreen) {
            [_imageView setContentMode:UIViewContentModeScaleAspectFit];
//        } else {
//            [_imageView setContentMode:UIViewContentModeScaleAspectFill];
//        }
        [self addSubview:_imageView];
        _imageView.frame = self.frame;
        [_imageView setBackgroundColor:[UIColor clearColor]];
        _imageView.image = nil;
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //            UIImage *backImage = [UIImage imageNamed:name];
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                _imageView.image = backImage;
        //            });
        //        });
    }
    //    [_imageView hnk_setImageFromURL:[NSURL URLWithString:imageInfo[@"img"]]];
//    if ([imageInfo isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *img = imageInfo[@"img"];
//        [_imageView hnk_setImageFromURL:[NSURL URLWithString:img[@"url"]]];
//    } else if ([imageInfo isKindOfClass:[NSString class]]) {
//        [_imageView hnk_setImageFromURL:[NSURL URLWithString:(NSString *)imageInfo]];
//    }
    NSDictionary *file = imageInfo[@"file"];
//    NSDictionary *thumbImageInfo = file[@"thumb"];
    NSString *urlString = file[@"url"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://restaurantfinder.boxnets.com%@",urlString]];
    [_imageView hnk_setImageFromURL:url];

}

- (void)layoutSubviews {
    [_imageView setFrame:self.bounds];
    [super layoutSubviews];
}

@end
