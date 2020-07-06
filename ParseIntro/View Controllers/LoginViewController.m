//
//  LoginViewController.m
//  ParseIntro
//
//  Created by Angela Xu on 7/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"

// TODO: check if username is taken first and have secialized error msg for that when sign up

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *pwField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) UIAlertController *emptyUsernameAlert;
@property (nonatomic, strong) UIAlertController *emptyPWAlert;
@property (nonatomic, strong) UIAlertController *badLoginAlert;
@property (nonatomic, strong) UIAlertController *usernameTakenAlert;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self alertSetUp];
    
    
}

- (void) alertSetUp {
    self.emptyUsernameAlert = [UIAlertController alertControllerWithTitle:@"Missing username."
           message:@"Please input your username."
    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [self.emptyUsernameAlert addAction:okAction];
    
    self.emptyPWAlert = [UIAlertController alertControllerWithTitle:@"Missing password."
           message:@"Please input your password."
    preferredStyle:(UIAlertControllerStyleAlert)];
    [self.emptyPWAlert addAction:okAction];
    
    self.badLoginAlert = [UIAlertController alertControllerWithTitle:@"Invalid credentials."
           message:@"Invalid login parameters, please try again."
    preferredStyle:(UIAlertControllerStyleAlert)];
    [self.badLoginAlert addAction:okAction];
    
    self.usernameTakenAlert = [UIAlertController alertControllerWithTitle:@"Username taken."
           message:@"Please try a different username."
    preferredStyle:(UIAlertControllerStyleAlert)];
    [self.usernameTakenAlert addAction:okAction];
}

- (IBAction)tappedSignUp:(id)sender {
    if ([self.usernameField.text isEqual:@""]) {
        [self presentViewController:self.emptyUsernameAlert animated:YES completion:^{  }];
    } else if ([self.pwField.text isEqual:@""]) {
        [self presentViewController:self.emptyPWAlert animated:YES completion:^{  }];
    } else {
        PFUser *newUser = [PFUser user];
        
        newUser.username = self.usernameField.text;
        newUser.password = self.pwField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                if (error.code == 202) {
                    [self presentViewController:self.usernameTakenAlert animated:YES completion:^{  }];
                } else {
                     UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                         message:[error localizedDescription]
                      preferredStyle:(UIAlertControllerStyleAlert)];
                      UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                      [tempAlert addAction:okAction];
                     [self presentViewController:tempAlert animated:YES completion:^{  }];
                }
            } else {
                NSLog(@"User registered successfully");
                
                // manually segue to logged in view
            }
        }];
    }
}

- (IBAction)loginTapped:(id)sender {
    if ([self.usernameField.text isEqual:@""]) {
           [self presentViewController:self.emptyUsernameAlert animated:YES completion:^{  }];
       } else if ([self.pwField.text isEqual:@""]) {
           [self presentViewController:self.emptyPWAlert animated:YES completion:^{  }];
       } else {
        NSString *username = self.usernameField.text;
        NSString *password = self.pwField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                if (error.code == 101) {
                    [self presentViewController:self.badLoginAlert animated:YES completion:^{  }];
                } else {
                     UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                        message:error.localizedDescription
                     preferredStyle:(UIAlertControllerStyleAlert)];
                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                     [tempAlert addAction:okAction];
                    [self presentViewController:tempAlert animated:YES completion:^{  }];
                }
            } else {
                NSLog(@"User logged in successfully");
                
                // display view controller that needs to shown after successful login
            }
        }];
       }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
