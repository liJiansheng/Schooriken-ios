//
//  SchoorikenUser.m
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/6/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import "SchoorikenUser.h"

@implementation SchoorikenUser


+ (SchoorikenUser*)shared
{
    static dispatch_once_t onceToken;
    static SchoorikenUser * instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
