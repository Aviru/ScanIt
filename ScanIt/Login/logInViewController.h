//
//  ViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 23/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface logInViewController : superViewController

@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (strong, nonatomic) IBOutlet UITextField *txtSignInEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtSignInPassword;


@property (weak, nonatomic) IBOutlet UIButton *sinInBtnOutlet;


- (IBAction)backToHomeAction:(id)sender;

- (IBAction)signInAction:(id)sender;

- (IBAction)forgotPasswordAction:(id)sender;

@end

