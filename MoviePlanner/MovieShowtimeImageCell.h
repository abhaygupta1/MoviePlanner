//
//  MovieShowtimeImageCell.h
//  MoviePlanner
//
//  Created by  on 9/7/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieShowtimeImageCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *showtime;
@property (nonatomic, weak) IBOutlet UITextView *userList;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (IBAction)displayGestureForTapRecognizer:(UITapGestureRecognizer *)recognizer;

@end
