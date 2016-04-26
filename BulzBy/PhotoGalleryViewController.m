//
//  PhotoGalleryViewController.m
//  BulzBy
//
//  Created by Seby Feier on 23/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "PhotoGalleryCollectionViewCell.h"

@interface PhotoGalleryViewController()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {

}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PhotoGalleryViewController

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView reloadData];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    flowLayout = nil;

    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionView Datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoGalleryCollectionViewCell *cell = (PhotoGalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoGalleryCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    if (!cell) {
        cell = (PhotoGalleryCollectionViewCell *)[[PhotoGalleryCollectionViewCell alloc] initWithFrame:self.collectionView.bounds];
    }
    NSDictionary *image = [self.imagesArray objectAtIndex:indexPath.row];
    [cell loadImageWithInfo:image];
    
    return cell;
}

#pragma mark - UICollectionView Datasource Methods
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size =  self.collectionView.frame.size;
//    size.width -= 10;
    return size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
