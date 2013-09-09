//
//  MovieCell.h
//  MoviePlanner
//
//  Created by  on 8/22/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *confirmed;
@property (nonatomic, weak) IBOutlet UILabel *interested;
@property (nonatomic, weak) IBOutlet UIImageView *movieImage;

@end
