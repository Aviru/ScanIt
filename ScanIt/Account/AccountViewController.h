//
//  AccountViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 02/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : superViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *AcccountView;

@property (weak, nonatomic) IBOutlet UIImageView *userImgVw;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;

@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtShippingAddress;

@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;


@property (weak, nonatomic) IBOutlet UIButton *btnEditOutlet;

@property (strong, nonatomic) IBOutlet UIButton *leftPannelBtnOutlet;

@property (strong, nonatomic) IBOutlet UIButton *editImageBtnOutlet;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtnOutlet;



- (IBAction)EditAction:(id)sender;

- (IBAction)editImageAction:(id)sender;

- (IBAction)cancelAction:(id)sender;


//typedef void (^ALAssetsLibraryWriteImageCompletionBlock)(NSURL *assetURL, NSError *error);
//typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
//typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

@end
