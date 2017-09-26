//
//  TopTableViewController.m
//  Top Places
//
//  Created by Apple on 8/25/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "TopTableViewController.h"
#import "FlickrFetcherModification.h"
#import "PhotosTableViewController.h"

@interface TopTableViewController ()

@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSDictionary *placesByCountry;

@end

@implementation TopTableViewController

- (void)setTopPlaces:(NSArray *)topPlaces {
    if (_topPlaces == topPlaces) return;
    _topPlaces = [FlickrFetcherModification sortPlaces:topPlaces];
    self.placesByCountry = [FlickrFetcherModification placesByCountries:_topPlaces];
    self.countries = [FlickrFetcherModification countries:self.placesByCountry];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.frame.size.height) animated:YES];
    [FlickrFetcherModification downloadTopPlaces:^(NSArray *places, NSError *error) {
        if (!error) {
            self.topPlaces = places;
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"Error downloading data");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.placesByCountry[self.countries[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.countries[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Place Cell" forIndexPath:indexPath];
    NSDictionary *place = self.placesByCountry[self.countries[indexPath.section]][indexPath.row];
    cell.textLabel.text = [FlickrFetcherModification titleOfPlace:place];
    cell.detailTextLabel.text = [FlickrFetcherModification subtitleOfPlace:place];
  
    return cell;
}

- (void)preparePhotosTableViewController:(PhotosTableViewController *)TVC forPlace:(NSDictionary *)place {
    TVC.place = place;
    TVC.title = [FlickrFetcherModification titleOfPlace:place];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"Show Place"] && indexPath) {
        [self preparePhotosTableViewController:segue.destinationViewController forPlace:self.placesByCountry[self.countries[indexPath.section]][indexPath.row]];
    }
}


@end
