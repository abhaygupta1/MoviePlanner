//
//  MoviesTonightViewController.m
//  MoviePlanner
//
//  Created by  on 8/28/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "MoviesTonightViewController.h"
#import "MovieSelectorViewController.h"
#import "MovieCell.h"
#import "TMSClient.h"
#import "Movie.h"
#import "User.h"

@interface MoviesTonightViewController ()
@property (nonatomic, strong) NSMutableArray *movies;
@end


@implementation MoviesTonightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.movies = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    UINib *customNib = [UINib nibWithNibName:@"MovieCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"MovieCell"];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
                                            action:@selector(onCancelButton)];
    if (self.movies == nil) {
        [self reload];
    }
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor magentaColor];
    [refreshControl addTarget:self action:@selector(updateUsers) forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = refreshControl;
    self.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieCell";
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Movie *movie = (Movie *)(self.movies[indexPath.row]);
    cell.title.text = movie.title;
    UIImage *movieImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", movie.movieId]];
    if (movieImage != nil) {
        cell.imageView.image = movieImage;
    }
    cell.confirmed.text = [@([User confirmCountForMovie:[movie title]]) stringValue];
    cell.interested.text = [@([User interestCountForMovie:[movie title]]) stringValue];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieSelectorViewController *movieSelectorVC = [[MovieSelectorViewController alloc] init];
    Movie *movie = (Movie *)self.movies[indexPath.row];
    movieSelectorVC.movie = movie;
    [self.navigationController pushViewController:movieSelectorVC animated:YES];
}



- (void)reload {
     [[TMSClient instance] movieListWithZipCode:@"95054" success:^(AFHTTPRequestOperation *operation, id response) {
     id payload = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
     NSLog(@"The response is %@", payload);
     self.movies = [Movie moviesWithArray:payload];
     [self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     // Do nothing
     NSLog(@"The response is %@", error);
     }];
    
}

- (void)updateUsers
{
    [User reloadfromTableView:self.tableView];
    NSLog(@"Reload called");
    [self.refreshControl endRefreshing];
}

@end
