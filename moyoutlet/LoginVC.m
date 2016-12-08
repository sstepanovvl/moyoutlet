//
//  ViewController.m
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "LoginVC.h"
#import "baseError.h"

@interface LoginVC ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UITextField *tf_authCode;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tf_authCodeConstraint;
@property (strong, nonatomic) IBOutlet UIButton *authButton;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tf_authCodeConstraint.constant = 0;
    /*
    [self.phoneNumberField.formatter setDefaultOutputPattern:@"(###) ###-##-##" imagePath:@"Flag RU"];
    self.phoneNumberField.formatter.prefix = @"+7 ";
     */
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButtonPressed:(id)sender {
/*
    if (![_phoneNumberField.phoneNumberWithoutPrefix isEqual:@""]){
        if ([_authButton.titleLabel.text  isEqual: @"Получить код"]) {
            [self.progressBar setProgress:0.0f animated:YES];
            NSDictionary* resp = [[AppManager sharedInstance] registerWithParams:@{@"PhoneNumber":self.phoneNumberField.phoneNumber}]   ;
            [self.progressBar setProgress:1.0f animated:YES];
            [_tf_authCode setText:[resp valueForKey:@"setAuthCode"]];

            _tf_authCodeConstraint.constant = 40;
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = _tf_authCode.frame;
                frame.size.height = 40;
                _tf_authCode.frame = frame;
                [self.authButton setTitle:@"Войти" forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                _tf_authCode.hidden = 0;
                _tf_authCode.text = [[resp valueForKey:@"sentAuthCode"] stringValue];

            }];
        } else {

            NSMutableDictionary* resp = [[NSMutableDictionary alloc] initWithDictionary:[[AppManager sharedInstance] registerWithParams:@{@"PhoneNumber":self.phoneNumberField.phoneNumber,@"AuthCode":_tf_authCode.text}]];
            if ([resp valueForKey:@"success"]) {
                baseError* err = [[baseError alloc] init];
                err.customHeader = @"Все хорошо";
                err.customError = [NSString stringWithFormat:@"Секретный код пользователя: %@",[resp valueForKey:@"accessToken"]];
                [self.view endEditing:YES];
                [self throughError:err];
                [AppManager sharedInstance].token = [resp valueForKey:@"accessToken"];
                [AppManager sharedInstance].newUser = [[resp valueForKey:@"newUser"] boolValue];
                [AppManager sharedInstance].authorized = YES;
            } else {
                NSString* error = [[resp valueForKey:@"error"] valueForKey:@"text"];
                baseError* err = [[baseError alloc]init];
                err.customHeader = @"Ошибка с сервера";
                err.customError = error;
                [self throughError:err];
            }
        }
    }
 */
}

@end
