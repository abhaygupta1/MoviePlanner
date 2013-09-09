//
//  MovieShowtimeImageCell.m
//  MoviePlanner
//
//  Created by  on 9/7/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "MovieShowtimeImageCell.h"

@implementation MovieShowtimeImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)displayGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer {
    NSLog(@"YYYYYYYY Got a tap for %@", self.title.text);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Movie Popup"
                                                    message:self.title.text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
