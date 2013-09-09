//
//  MovieSelectorViewController.m
//  MoviePlanner
//
//  Created by  on 8/29/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "MovieSelectorViewController.h"
#import "MovieShowtimeCell.h"
#import "FriendTableViewCell.h"
#import "AFNetworking.h"
#import "Movie.h"
#import "User.h"

@interface MovieSelectorViewController ()

@end

NSArray *showtimesRaw;
NSArray *showtimeStrings;

@implementation MovieSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    UINib *movieShowtimeCellNib = [UINib nibWithNibName:@"MovieShowtimeCell" bundle:nil];
    [self.tableView registerNib:movieShowtimeCellNib forCellReuseIdentifier:@"ShowtimeCell"];
    self.name.text = [self.movie title];
    UIImage *movieImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self.movie.movieId]];
    if (movieImage != nil) {
        self.imageView.image = movieImage;
    }
    showtimesRaw = [self.movie arrayWithShowtimesRaw];
    showtimeStrings = [self.movie arrayWithShowtimeStrings];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        // Return the number of rows in the section.
    return showtimesRaw.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"ShowtimeCell";
    NSLog(@"Getting the showtime cell %d", indexPath.row);
    
    
    MovieShowtimeCell *showtimeCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    showtimeCell.showtime.text = showtimeStrings[indexPath.row];
    NSString *datetime = [showtimesRaw[indexPath.row] valueOrNilForKeyPath:@"dateTime"];
    NSDictionary *theatre = [showtimesRaw[indexPath.row] valueOrNilForKeyPath:@"theatre"];
    NSString *theatreName = [theatre valueForKey:@"name"];
    showtimeCell.textView.text =
    [User userListForMovieShowtime:self.movie.title theatre:theatreName time: datetime];
    
    return showtimeCell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *datetime = [showtimesRaw[indexPath.row] valueOrNilForKeyPath:@"dateTime"];
    NSDictionary *theatre = [showtimesRaw[indexPath.row] valueOrNilForKeyPath:@"theatre"];
    NSString *theatreName = [theatre valueForKey:@"name"];
    NSString *userList =
        [User userListForMovieShowtime:self.movie.title theatre:theatreName time: datetime];
    CGSize size = [userList sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10] constrainedToSize:CGSizeMake(160, 999) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f",size.height);
    return size.height + 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedCells = [self.tableView indexPathsForSelectedRows];
    NSLog(@"The selected row are %@", selectedCells);
}

- (IBAction)operationPressed:(UIButton *)sender {
    NSLog(@"Add button called");
    NSArray *selectedCells = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedCells) {
        NSString *title = [self.movie title];
        NSString *movieId = [self.movie movieId];
        NSDictionary *theatre = [showtimesRaw[indexPath.row] valueOrNilForKeyPath:@"theatre"];
        NSString *theatreName = [theatre valueForKey:@"name"];
        NSString *dateTime = [showtimesRaw[indexPath.row] valueOrNilForKeyPath:@"dateTime"];
        [User addMovieToCurrentUserWithTitle:title tmsId:movieId theatre:theatreName dateTime:dateTime];
        
    }
    [User saveCurrentUser];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateUsers
{
    [User reloadfromTableView:self.tableView];
    NSLog(@"Reload called");
    [self.refreshControl endRefreshing];
}

@end
