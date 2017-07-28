//
//  ProductListCollectionViewCell.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 12/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImgVw;

@property (weak, nonatomic) IBOutlet UILabel *lblProductName;

@property (strong, nonatomic) IBOutlet UILabel *lblProductPrice;


@end
