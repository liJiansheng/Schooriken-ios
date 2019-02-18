//
//  SchoorikenLoginViewController.m
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/5/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import "SchoorikenLoginViewController.h"
#import "SchoorikenConstants.h"
#import "SchoorikenUser.h"
#import "NSString+MD5.h"

@interface SchoorikenLoginViewController ()
- (void) tryLogin:(NSString*)username password:(NSString*)password;
- (void) goToDashboard:(NSString*)username;
@property UITextField * usernameTextField;
@property UITextField * passwordTextField;
@property UILabel * errorLabel;
@end

@implementation SchoorikenLoginViewController

- (void) tryLogin:(NSString*)username password:(NSString*)password
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.errorLabel.text = @"Loading...";
        [self.errorLabel setNeedsDisplay];
    });
    
    //[self goToDashboard:username];
    //return;
    
    password = [password MD5];
    NSURL * url = [NSURL URLWithString:API_URL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];

    NSString * str = [NSString stringWithFormat:@"user=%@&pass=%@",username,password];
    NSData * postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSString * str;
        if ([data length] > 0 && error == nil) {
            //Failed, print error message
            NSLog(@"Received data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            str = @"Invalid email or password.";
        } else if ([data length] == 0 && error == nil) {
            //Login successful, do login stuff
            str = @"Logged in!";
            [[SchoorikenUser shared] setUsername:username];
            [[SchoorikenUser shared] setPassword:password];
            NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:username forKey:@"username"];
            [prefs setObject:password forKey:@"password"];
            [self goToDashboard:username];
            //[self performSegueWithIdentifier:@"toDashboard" sender:self];
        } else {
            NSLog(@"ERROR: %@", error);
            str = [error localizedDescription];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.errorLabel.text = str;
            [self.errorLabel setNeedsDisplay];
        });
    }];
}

- (void) goToDashboard:(NSString*)username
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"goToDashboard" sender:self];
    });
    return;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) registerForKeyboardNotificaions
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) deregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}


- (void) keyboardWillBeShown:(NSNotification *) notification
{
    NSDictionary * info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint fieldOrigin = self.passwordTextField.frame.origin;
    CGFloat fieldHeight = self.passwordTextField.frame.size.height;
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(visibleRect, fieldOrigin)) {
        CGPoint scrollPoint = CGPointMake(0.0, fieldOrigin.y - visibleRect.size.height + fieldHeight*1.5);
        [(UIScrollView*)self.view setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification*) notification
{
    [(UIScrollView*)self.view setContentOffset:CGPointZero animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.passwordTextField.text = @"";
    self.errorLabel.text = @"";
    //self.navigationController.navigationBarHidden = YES;
    //self.navigationController.toolbarHidden = YES;
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSString * username = [prefs stringForKey:@"username"];
    NSString * password = [prefs stringForKey:@"password"];
    for (UIView * view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField*) view;
            if (textField.tag == 0) {
                self.usernameTextField = textField;
            } else if (textField.tag == 1) {
                self.passwordTextField = textField;
            }
        } else if ([view isKindOfClass:[UILabel class]]) {
            self.errorLabel = (UILabel*) view;
        }
    }
    [self registerForKeyboardNotificaions];
    if (username!=nil && password!=nil) {
        self.usernameTextField.text = username;
        [[SchoorikenUser shared] setUsername:username];
        [[SchoorikenUser shared] setPassword:password];
        [self goToDashboard:username];
        return;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self deregisterFromKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.passwordTextField) {
        [self tryLogin:self.usernameTextField.text password:textField.text];
    } else if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}

- (BOOL) textFieldDidEndEditing: (UITextField*)textField
{
    //[textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
