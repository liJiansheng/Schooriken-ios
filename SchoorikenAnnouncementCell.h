//
//  SchoorikenAnnouncementCell.h
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/6/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoorikenAnnouncementCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel * groupLabel;
@property (nonatomic,weak) IBOutlet UILabel * nameLabel;
@property (nonatomic,weak) IBOutlet UILabel * detailsLabel;
@property (nonatomic,weak) IBOutlet UIImageView * imageView;
@property (nonatomic,weak) IBOutlet UILabel * dateLabel;


@end
