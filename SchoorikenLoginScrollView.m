//
//  SchoorikenLoginScrollVIew.m
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/5/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import "SchoorikenLoginScrollView.h"

@interface SchoorikenLoginScrollView ()

@property UITextField * btmTextField;

@end

@implementation SchoorikenLoginScrollView

- (void) registerForKeyboardNotificaions
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
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
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
}


- (void) keyboardWasShown:(NSNotification *) notification
{
    NSDictionary * info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint fieldOrigin = self.btmTextField.frame.origin;
    CGFloat fieldHeight = self.btmTextField.frame.size.height;
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(visibleRect, fieldOrigin)) {
        CGPoint scrollPoint = CGPointMake(0.0, fieldOrigin.y - visibleRect.size.height + fieldHeight);
        [self setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification*) notification
{
    [self setContentOffset:CGPointZero animated:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
