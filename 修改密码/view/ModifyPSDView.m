//
//  ModifyPSDView.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/21.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "ModifyPSDView.h"
#import "Header.h"

@interface ModifyPSDView ()<UITextFieldDelegate>

@end

@implementation ModifyPSDView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    self.logoIv.layer.cornerRadius = 41.0;
    self.bgView.clipsToBounds = NO;
    self.bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.bgView.layer.shadowRadius = 1.0f;
    self.bgView.layer.shadowOpacity = 0.8;
    self.oldPSDTextField.delegate = self;
    self.modifyPSDTextField.delegate = self;
    self.surePSDTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    NSLog(@"%@", noti.userInfo);
    CGRect keyboardBounds;
    [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGFloat textY;
    if (self.oldPSDTextField.editing) {
        CGRect textFrame = [self convertRect:self.oldPSDTextField.frame fromView:self.oldPSDTextField.superview];
        //NSLog(@"%@",NSStringFromCGRect(textFrame));
        textY = kScreenHeight - (64.0 + textFrame.origin.y + textFrame.size.height + keyboardBounds.size.height);
    }
    else if (self.modifyPSDTextField.editing) {
        CGRect textFrame = [self convertRect:self.modifyPSDTextField.frame fromView:self.modifyPSDTextField.superview];
        //NSLog(@"%@",NSStringFromCGRect(textFrame));
        textY = kScreenHeight - (64.0 + textFrame.origin.y + textFrame.size.height + keyboardBounds.size.height);
        //NSLog(@"%f",textY);
    } else if (self.surePSDTextField.editing) {
        CGRect textFrame = [self convertRect:self.surePSDTextField.frame fromView:self.surePSDTextField.superview];
        //NSLog(@"%@",NSStringFromCGRect(textFrame));
        textY = kScreenHeight - (64.0 + textFrame.origin.y + textFrame.size.height + keyboardBounds.size.height);
    }
    if (textY < 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [UIView setAnimationDelegate:self];
        self.y = textY;
        [UIView commitAnimations];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)noti{
    NSLog(@"%@", noti.userInfo);
    CGRect keyboardBounds;
    [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    self.y = 0.0;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.oldPSDTextField) {
        [textField resignFirstResponder];
        [self.modifyPSDTextField becomeFirstResponder];
    }else if (textField == self.modifyPSDTextField) {
        [textField resignFirstResponder];
        [self.surePSDTextField becomeFirstResponder];
    } else if (textField == self.surePSDTextField) {
        [textField resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(config)]) {
            [self.delegate config];
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.oldPSDTextField) {
        //
    }else if (textField == self.modifyPSDTextField) {
        if ([self.surePSDTextField.text length] != 0 && [textField.text length] != 0) {
            if (![self.surePSDTextField.text isEqualToString:textField.text]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                textField.text = @"";
                [alert show];
            }
        }
    } else if (textField == self.surePSDTextField) {
        if ([self.modifyPSDTextField.text length] != 0 && [textField.text length] != 0) {
            if (![self.modifyPSDTextField.text isEqualToString:textField.text]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                textField.text = @"";
                [alert show];
            }
        }
    }
}

- (IBAction)modifyButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(config)]) {
        [self.delegate config];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
