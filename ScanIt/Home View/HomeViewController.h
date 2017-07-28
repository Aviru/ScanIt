//
//  HomeViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 02/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : superViewController<UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,CloudSightQueryDelegate,CloudSightImageRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblOpenCamera;

@property (weak, nonatomic) IBOutlet UIImageView *capturedImgVw;

@property (weak, nonatomic) IBOutlet UILabel *lblProcessingImage;

@property (strong, nonatomic) IBOutlet UIButton *leftBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *openCameraBtnOutlet;



- (IBAction)leftPannelAction:(id)sender;

- (IBAction)openCameraAction:(id)sender;


@property BOOL isImageAvailable;

@end
