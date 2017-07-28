//
//  SuggestedRetailersTableViewCell.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 09/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestedRetailersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblShopName;

@property (weak, nonatomic) IBOutlet UILabel *lblShopAddress;

@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *callUsBtnOutlet;

@property (strong, nonatomic) IBOutlet UILabel *lblShopType;

@property (strong, nonatomic) IBOutlet UIImageView *offersImgVwIcon;

@end
