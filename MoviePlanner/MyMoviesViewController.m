//
//  MyMoviesViewController.m
//  MoviePlanner
//
//  Created by  on 8/24/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "AFNetworking.h"
#import "MyMoviesViewController.h"
#import "MovieCell.h"
#import "MovieShowtimeImageCell.h"
#import "Movie.h"
#import "User.h"
#import "SherpaClient.h"
#import "MoviesTonightViewController.h"

@interface MyMoviesViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *confirmedMovies;
@property (nonatomic, strong) NSMutableArray *interestedMovies;

@end
UINavigationController *moviesTonightNVC;

@implementation MyMoviesViewController

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
    
    UINib *customNib = [UINib nibWithNibName:@"MovieShowtimeImageCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"MovieShowtimeImageCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                             action:@selector(onAddButton)];
    
    [self.tableView setEditing:YES animated:YES];
    [self.tableView reloadData];
   
    MoviesTonightViewController *moviesTonightViewController = [[MoviesTonightViewController alloc] init];
    moviesTonightNVC = [[UINavigationController alloc]
                                                initWithRootViewController:moviesTonightViewController];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor magentaColor];
    [refreshControl addTarget:self action:@selector(updateUsers) forControlEvents:UIControlEventValueChanged];

    tableViewController.refreshControl = refreshControl;
    self.refreshControl = refreshControl;
    [User reloadfromTableView:self.tableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSignOutButton {
    
    // Do Nothing
}

- (void)onAddButton {
    
    //MoviesTonightViewController *moviesTonightViewController = [[MoviesTonightViewController alloc] init];
    //UINavigationController *moviesTonightNVC = [[UINavigationController alloc]
    //                                            initWithRootViewController:moviesTonightViewController];
    [self.navigationController presentViewController:moviesTonightNVC animated:YES completion:nil];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0: { // Confirmed Section
            if ([(Movie *)([User getCurrentUser].movies[0]) isEmpty])
                 return 0;
            else
                 return 1;
            break;
        }
        case 1: { // Interested Section
            return [User getCurrentUser].movies.count - 1;
        }
        default: return 0;
    }
}


// Return Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieShowtimeImageCell";
    MovieShowtimeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Movie *movie;
    switch (indexPath.section) {
        case 0: { // Confirmed Section
            movie = ((Movie *)([User getCurrentUser].movies[0]));
            break;
        }
        case 1: { // Interested Section
            movie = ((Movie *)([User getCurrentUser].movies[indexPath.row + 1]));
            break;
        }
        default: movie = nil;
    }
    
    // set labels
    cell.title.text = [movie title];
    cell.showtime.text = [movie stringWithShowtime];
    cell.userList.text =
        [User userFullListForMovieShowtime:movie.title theatre:[movie theatre] time:[movie dateTime]];
    
    // Tap Recongnizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                     initWithTarget:cell action:@selector(displayGestureForTapRecognizer:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [cell.userList addGestureRecognizer:tapRecognizer];
    
    // set image
    //[cell.imageView setImageWithURL:[NSURL URLWithString:@"file:///Users/abhayg/Desktop/142799H1.jpg"]];
    UIImage *movieImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", movie.movieId]];
    if (movieImage != nil) {
        cell.imageView.image = movieImage;
    }

    
    // make it reorderable
    [cell setShowsReorderControl:YES];
    
    return cell;
}

// Return Cell Height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie;
    switch (indexPath.section) {
        case 0: {
            movie = ((Movie *)([User getCurrentUser].movies[0]));
            break;
        }
        case 1: {
            movie = ((Movie *)([User getCurrentUser].movies[indexPath.row + 1]));
            break;
        }
        default: movie = nil;
    }
    NSString *userList = [User userFullListForMovieShowtime:movie.title theatre:[movie theatre] time:[movie dateTime]];
    CGSize size = [userList sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10] constrainedToSize:CGSizeMake(160, 999) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f",size.height);
    return size.height + 75;
}

// Return Cell for the Section Heading
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle;
    
    switch (section) {
        case 0: {
            sectionTitle = @"Confirm List";
            break;
        }
        case 1: {
            sectionTitle = @"Interest List";
            break;
        }
        default: sectionTitle = nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 360, 23);
    label.textColor = [UIColor blueColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:18];
    label.text = sectionTitle;
    label.backgroundColor = [UIColor grayColor];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 100)];
    [view addSubview:label];
    
    return view;
}

// Return Height for the Section Heading
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *movies = [User getCurrentUser].movies;
    // there are three scenarios
    if (fromIndexPath.section == 0) {
        // scenario 1 => moving from confirmed to interested
        Movie *movie = movies[0];
        [movies removeObjectAtIndex:0];
        [movies insertObject:movie atIndex:toIndexPath.row];
        [movies insertObject: [Movie emptyMovie] atIndex:0];
    }
    else if (toIndexPath.section == 0) {
        // scenario 2 => moving from interested to confirmed
        Movie *movie = movies[fromIndexPath.row + 1];
        [movies removeObjectAtIndex:(fromIndexPath.row + 1)];
        if ([(Movie *)(movies[0]) isEmpty]) {
            [movies removeObjectAtIndex:0];
        }
        [movies insertObject:movie atIndex:0];
    }
    else {
        // scenario 3 => moving within interested
        Movie *movie = movies[fromIndexPath.row + 1];
        [movies removeObjectAtIndex:(fromIndexPath.row + 1)];
        [movies insertObject:movie atIndex:(toIndexPath.row + 1)];
    }
    [self.tableView reloadData];
    [User saveCurrentUser];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *movies = [User getCurrentUser].movies;
        // Delete the row from the data source
        if (indexPath.section == 0) {
            // replace with empty
            [movies removeObjectAtIndex:indexPath.row];
            [movies insertObject: [Movie emptyMovie] atIndex:0];
        }
        else {
            // remove the element
            [movies removeObjectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [User saveCurrentUser];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }
}

#pragma mark - Button Handler

- (IBAction)operationPressed:(UIButton *)sender {
    NSLog(@"Purge button pressed");
    NSMutableArray *movies = [User getCurrentUser].movies;
    while (movies.count > 1) {
        [movies removeObjectAtIndex:1];
    }
    [User saveCurrentUser];
    [self.tableView reloadData];
}


- (void)updateUsers
{
    [User reloadfromTableView:self.tableView];
    NSLog(@"Reload called");
    [self.refreshControl endRefreshing];
}

@end
