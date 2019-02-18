//
//  SchoorikenAssignmentCell.h
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/6/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoorikenCompleteButton.h"

@interface SchoorikenAssignmentCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel * groupLabel;
@property (nonatomic,weak) IBOutlet UILabel * nameLabel;
@property (nonatomic,weak) IBOutlet UILabel * detailsLabel;
@property (nonatomic,weak) IBOutlet SchoorikenCompleteButton * completeButton;
@property (nonatomic,weak) IBOutlet UILabel * daysLeftLabel;
@property (nonatomic,weak) IBOutlet UILabel * dateLabel;

@end
