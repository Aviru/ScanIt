//
//  LikesTableViewCell.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 13/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *likedProductImgVw;

@property (weak, nonatomic) IBOutlet UILabel *lblLikedProductName;

@property (strong, nonatomic) IBOutlet UIView *VwBg;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@end
