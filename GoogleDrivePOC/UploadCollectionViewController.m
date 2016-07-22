//
//  UploadCollectionViewController.m
//  GoogleDrivePOC
//
//  Created by Rupak Parikh on 21/07/16.
//  Copyright © 2016 Avira Operations GmbH & Co. KG. All rights reserved.
//

#import "SVProgressHUD.h"
#import "UploadCollectionViewController.h"
#import "cellCollectionViewCell.h"
@interface UploadCollectionViewController ()
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* dict;
@property (nonatomic, strong) NSMutableArray* selectedIndex;

@end

@implementation UploadCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 80) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];

    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setAllowsMultipleSelection:TRUE];

    [self.view addSubview:_collectionView];

    _dict = [NSArray arrayWithObjects:@"dog1", @"dog2", @"dog3", @"dog4", nil];
    _selectedIndex = [[NSMutableArray alloc] init];
    self.title = @"Upload Photos";

    UIBarButtonItem* anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFile)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dict count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_dict objectAtIndex:indexPath.row]]];
    UIView* aView = [cell viewWithTag:11];
    [aView removeFromSuperview];

    return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake(150, 150);
}
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{

    UICollectionViewCell* datasetCell = [collectionView cellForItemAtIndexPath:indexPath];
    UIView* _coverView = [[UIView alloc] initWithFrame:datasetCell.bounds];
    _coverView.translatesAutoresizingMaskIntoConstraints = NO;
    _coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _coverView.backgroundColor = [UIColor colorWithRed:0.24 green:0.47 blue:0.85 alpha:0.7];
    _coverView.tag = 11;
    [datasetCell addSubview:_coverView];

    [_selectedIndex addObject:indexPath];
}

- (void)collectionView:(UICollectionView*)collectionView didDeselectItemAtIndexPath:(NSIndexPath*)indexPath
{

    UICollectionViewCell* datasetCell = [collectionView cellForItemAtIndexPath:indexPath];
    UIView* aView = [datasetCell viewWithTag:11];
    [aView removeFromSuperview];
    [_selectedIndex removeObject:indexPath];
}
- (void)uploadFile
{

    if ([_selectedIndex count] > 0) {

        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Remaining image %ld", [_selectedIndex count]]];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

        NSIndexPath* indexpath = (NSIndexPath*)[_selectedIndex objectAtIndex:0];
        NSString* filePath = [[NSBundle mainBundle] pathForResource:[_dict objectAtIndex:indexpath.row] ofType:@"png"];

        NSString* mimeType = @"image/png";
        //NSFileHandle* fileHandler = [NSFileHandle fileHandleForReadingAtPath:filePath];
        GTLUploadParameters* uploadParameters = [GTLUploadParameters uploadParametersWithFileURL:[NSURL fileURLWithPath:filePath] MIMEType:mimeType];
        GTLDriveFile* file = [GTLDriveFile object];

        file.name = [NSString stringWithFormat:@"%@.png", [_dict objectAtIndex:indexpath.row]];
        file.mimeType = mimeType;

        GTLQueryDrive* query = [GTLQueryDrive queryForFilesCreateWithObject:file
                                                           uploadParameters:uploadParameters];
        [self.service executeQuery:query completionHandler:^(GTLServiceTicket* ticket,
                                             GTLDriveFile* updatedFile,
                                             NSError* error) {
            if (error == nil) {
                NSLog(@"File %@", updatedFile);
                [_selectedIndex removeObjectAtIndex:0];
                [self uploadFile];
            }
            else {

                NSLog(@"An error occurred: %@", error);
            }

        }];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Upload" message:@"Upload finished." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [SVProgressHUD dismiss];
        [self.collectionView reloadData];
    }
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
