//
//  ForgotPasswordViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 15/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : superViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *submitBtnOutlet;
@property (weak, nonatomic) IBOutlet UIView *forgotPassView;


- (IBAction)submitEmailAction:(id)sender;

- (IBAction)backToSignInAction:(id)sender;

@end
