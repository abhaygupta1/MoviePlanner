//
//  MoviesTonightViewController.h
//  MoviePlanner
//
//  Created by  on 8/28/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesTonightViewController : UIViewController<
UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;


@end
