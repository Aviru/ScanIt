//
//  SuggestedRetailerDetailsViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 13/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestedRetailerDetailsViewController : UIViewController<UIDocumentInteractionControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *lblShopName;

@property (weak, nonatomic) IBOutlet UILabel *lblShopAddress;

@property (weak, nonatomic) IBOutlet UILabel *lblTimings;

@property (weak, nonatomic) IBOutlet UILabel *lblContact;

@property (weak, nonatomic) IBOutlet STTweetLabel *lblWebSite;


- (IBAction)backToSuggestedRetailers:(id)sender;

- (IBAction)callUsAction:(id)sender;

@property(strong,nonatomic)NSMutableArray *arrSuggestedRetailerDetails;


@end
