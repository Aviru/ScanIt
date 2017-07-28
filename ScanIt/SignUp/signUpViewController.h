//
//  signUpViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 24/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signUpViewController : superViewController

@property (strong, nonatomic) IBOutlet UIView *firstVw;

@property (strong, nonatomic) IBOutlet UIView *secondVw;

@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;

@property (strong, nonatomic) IBOutlet UITextField *txtLastName;

@property (strong, nonatomic) IBOutlet UITextField *txtEmailAddress;

@property (strong, nonatomic) IBOutlet UITextField *txtMobileNumber;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPassword;


- (IBAction)doneAction:(id)sender;

- (IBAction)backToHomeAction:(id)sender;

-(void) keyboardWillHide:(NSNotification *)note;
-(void) keyboardWillShow:(NSNotification *)note;

@end
