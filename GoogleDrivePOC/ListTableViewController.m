//
//  ListTableViewController.m
//  GoogleDrivePOC
//
//  Created by Rupak Parikh on 16/07/16.
//  Copyright © 2016 Avira Operations GmbH & Co. KG. All rights reserved.
//

#import "GTLUploadParameters.h"
#import "ListTableViewController.h"
#import "PhotoViewController.h"
#import "SVProgressHUD.h"
#import "UploadCollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ListTableViewController ()

@end

@implementation ListTableViewController
@synthesize fileList;
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    UIBarButtonItem* anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFile)];
    self.navigationItem.rightBarButtonItem = anotherButton;

    self.title = @"Photos from Drive";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [self.fileList count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    GTLDriveFile* file = [self.fileList objectAtIndex:indexPath.section];
    cell.textLabel.text = file.name;

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:file.thumbnailLink]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]];

    return cell;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{

    UIView* view = [[UIView alloc] init];
    [view setAlpha:0.0F];
    return view;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{

    return 10;
}
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundView:nil];
    //[cell setBackgroundColor:[UIColor lightGrayColor]];
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

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    GTLServiceDrive* drive = self.service;
    GTLDriveFile* file = [self.fileList objectAtIndex:indexPath.section];
    NSString* url = [NSString stringWithFormat:@"https://www.googleapis.com/drive/v3/files/%@?alt=media",
                              file.identifier];

    NSLog(@"%@", file.thumbnailLink);
    GTMSessionFetcher* fetcher = [drive.fetcherService fetcherWithURLString:url];
    [SVProgressHUD showWithStatus:@"Downloading"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [fetcher beginFetchWithCompletionHandler:^(NSData* data, NSError* error) {
        if (error == nil) {
            NSLog(@"Retrieved file content");
            // Do something with data
            UIImage* image = [UIImage imageWithData:data];
            // Navigation logic may go here, for example:
            // Create the next view controller.

            PhotoViewController* detailViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
            detailViewController.image = image;

            // Push the view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        else {
            NSLog(@"An error occurred: %@", error);
        }
        [SVProgressHUD dismiss];

    }];
}

- (void)uploadFile
{
    UploadCollectionViewController* collectionView = [[UploadCollectionViewController alloc] init];
    collectionView.service=self.service;
    [self.navigationController pushViewController:collectionView animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
