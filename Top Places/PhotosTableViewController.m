//
//  PhotosTableViewController.m
//  Top Places
//
//  Created by Apple on 9/25/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcherModification.h"
#import "PhotoViewController.h"

@interface PhotosTableViewController ()

@property (strong, nonatomic) NSArray *photos;

@end

@implementation PhotosTableViewController

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

#define MAX_PHOTO_RESULTS 50

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.frame.size.height) animated:YES];
    [FlickrFetcherModification downloadPhotosForPlace:self.place numOfResults:MAX_PHOTO_RESULTS onCompletion:^(NSArray *photos, NSError *error) {
        if (!error) {
            self.photos = photos;
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"Error downloading photos");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo Cell" forIndexPath:indexPath];
    NSDictionary *photo = self.photos[indexPath.row];
    NSString *title = [photo valueForKey:FLICKR_PHOTO_TITLE];
    NSString *description = [photo valueForKey:FLICKR_PHOTO_DESCRIPTION];
    if (![description length]) description = @"Unknown";
    if (![title length]) title = description;
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    
    return cell;
}

- (void)preparePhotoViewController:(PhotoViewController *)VC forPhoto:(NSDictionary *)photo {
    VC.imageURL = [FlickrFetcherModification URLforPhoto:photo format:FlickrPhotoFormatOriginal];
    NSString *title = [photo valueForKey:FLICKR_PHOTO_TITLE];
    VC.title = ([title length]) ? title : @"Unknown";
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"Show Photo"] && indexPath) {
        [self preparePhotoViewController:[segue.destinationViewController.childViewControllers firstObject] forPhoto:self.photos[indexPath.row]];
    }
}


@end
