//
//  SchoorikenUser.h
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/6/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoorikenUser : NSObject

+ (SchoorikenUser*)shared;
@property NSString * username;
@property NSString * password;

@end
