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
#import "Movie.h"
#import "User.h"
#import "SherpaClient.h"
#import "MoviesTonightViewController.h"

@interface MyMoviesViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *confirmedMovies;
@property (nonatomic, strong) NSMutableArray *interestedMovies;

@end

@implementation MyMoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           [self reload];
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                             action:@selector(onAddButton)];
    
    [self.tableView setEditing:YES animated:YES];

   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAddButton {
    
    MoviesTonightViewController *moviesTonightViewController = [[MoviesTonightViewController alloc] init];
    UINavigationController *moviesTonightNVC = [[UINavigationController alloc]
                                                initWithRootViewController:moviesTonightViewController];
    [self.navigationController presentViewController:moviesTonightNVC animated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"Calling get row count for %d", section);
    switch (section) {
        case 0: {
            return self.confirmedMovies.count;
            break;
        }
        case 1: {
            return self.interestedMovies.count;
        }
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieCell";
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSLog(@"Called set table cell %d", indexPath.section);

    
    // Configure the cell...
    //cell.title.text = ((Movie *)(self.movies[indexPath.row])).title;
    //[cell.imageView setImageWithURL:[NSURL URLWithString:((Movie *)(self.movies[indexPath.row])).image]];
    switch (indexPath.section) {
        case 0: {
            cell.title.text = ((Movie *)(self.confirmedMovies[indexPath.row])).title;
            break;
        }
        case 1: {
            cell.title.text = ((Movie *)(self.interestedMovies[indexPath.row])).title;
            break;
        }
        default: cell.title.text = nil;
    }

    [cell.movieImage setImageWithURL:[NSURL URLWithString:@"file:///Users/abhayg/Desktop/142799H1.jpg"]];
    [cell setShowsReorderControl:YES];
    return cell;
}

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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;

}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{

}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)reload {
    
    [[SherpaClient instance] userWithName:@"sameer1" success:^(AFHTTPRequestOperation *operation, id response) {
        id payload = [NSJSONSerialization JSONObjectWithData:response options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"The response is %@", payload);
        
        NSDictionary *params = [payload valueForKey:@"ydht"];
        NSLog(@"The params are %@", params);
        NSLog(@"The user fields are %@", [params valueForKey:@"fields"]);

        
        User *user = [[User alloc] initWithDictionary:[params valueForKey:@"fields"]];
        
        NSLog(@"The confirmed is %@", [user confirmed]);
        
        self.confirmedMovies = [User moviesWithArray:[user confirmed]];
        self.interestedMovies = [User moviesWithArray:[user interested]];
        NSLog(@"Calling reload again");
        [self.tableView reloadData];
        User.currentUser = user;
        [User saveCurrentUser];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"The response is %@", error);
    }];
    

    
}

@end
