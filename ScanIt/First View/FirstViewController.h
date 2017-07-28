//
//  homeViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 24/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : superViewController

@property (strong, nonatomic) IBOutlet UIButton *signInBtnOtlet;

@property (strong, nonatomic) IBOutlet UIButton *signUpBtnOutlet;

@property (strong, nonatomic) IBOutlet UIButton *fbLoginBtnOutlet;

@property (weak, nonatomic) IBOutlet UIButton *loginAsGuestBtnOutlet;


- (IBAction)fbLoginAction:(id)sender;


- (IBAction)loginAsGuestAction:(id)sender;


@end
