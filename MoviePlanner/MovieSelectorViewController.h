//
//  MovieSelectorViewController.h
//  MoviePlanner
//
//  Created by  on 8/29/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieSelectorViewController : UIViewController <
UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) Movie *movie;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;

@property (nonatomic, weak) IBOutlet UILabel *name;

@property (nonatomic, strong) IBOutlet UIButton *addButton;
- (IBAction)operationPressed:(UIButton *)sender;

@end
