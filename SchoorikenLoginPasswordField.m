//
//  SchoorikenLoginPasswordField.m
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/5/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import "SchoorikenLoginPasswordField.h"

@implementation SchoorikenLoginPasswordField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"%@", textField.text);
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
