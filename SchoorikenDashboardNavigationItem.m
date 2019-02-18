//
//  SchoorikenDashboardNavigationItem.m
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/5/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import "SchoorikenDashboardNavigationItem.h"

@implementation SchoorikenDashboardNavigationItem

- (id) init
{
    self = [super init];
    if (self) {
        UIImageView * logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        CGPoint logoOrigin = logoImageView.frame.origin;
        CGFloat logoSize = self.titleView.frame.size.height*0.8;
        [logoImageView setFrame:CGRectMake(logoOrigin.x, logoOrigin.y, logoSize, logoSize)];
        [logoImageView setContentMode:UIViewContentModeScaleAspectFit];
        UIBarButtonItem * logo = [[UIBarButtonItem alloc] initWithCustomView:logoImageView];
        self.hidesBackButton = YES;
        self.leftBarButtonItem = logo;
    }
    return self;
}

@end
