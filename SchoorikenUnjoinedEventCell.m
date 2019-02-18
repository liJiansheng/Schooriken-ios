//
//  SchoorikenUnjoinedEventCell.m
//  Schooriken
//
//  Created by Chin Zhan Xiong on 5/6/14.
//  Copyright (c) 2014 ri. All rights reserved.
//

#import "SchoorikenUnjoinedEventCell.h"

@implementation SchoorikenUnjoinedEventCell

@synthesize groupLabel = _groupLabel;
@synthesize nameLabel = _nameLabel;
@synthesize detailsLabel = _detailsLabel;
@synthesize joinButton = _joinButton;
@synthesize imageView = _imageView;
@synthesize dateLabel = _dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
