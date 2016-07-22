//
//  ViewController.m
//  GoogleDrivePOC
//
//  Created by Rupak Parikh on 16/07/16.
//  Copyright © 2016 Avira Operations GmbH & Co. KG. All rights reserved.
//

#import "ListTableViewController.h"
#import "ViewController.h"
static NSString* const kKeychainItemName = @"GoogleDriveTest";
static NSString* const kClientID = @"CLIENT_ID";

@implementation ViewController

@synthesize service = _service;
@synthesize output = _output;

// When the view loads, create necessary subviews, and initialize the Drive API service.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];

    _files = [[NSMutableArray alloc] init];
    // Create a UITextView to display output.
    self.output = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.output.editable = false;
    self.output.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0);
    self.output.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.output];

    // Initialize the Drive API service & load existing credentials from the keychain if available.
    self.service = [[GTLServiceDrive alloc] init];
    self.service.authorizer =
        [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                              clientID:kClientID
                                                          clientSecret:nil];
    self.title = @"Google Drive POC";
}

// When the view appears, ensure that the Drive API service is authorized, and perform API calls.
- (void)viewDidAppear:(BOOL)animated
{ /*
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        // [self presentViewController:[self createAuthController] animated:YES completion:nil];
    }
    else {
        //     [self fetchFiles];
    }
  */
}

// Construct a query to get names and IDs of 10 files using the Google Drive API.
- (void)fetchFiles
{
    self.output.text = @"Getting files...";
    GTLQueryDrive* query =
        [GTLQueryDrive queryForFilesList];
    query.pageSize = 100;
    query.fields = @"nextPageToken, files";
    query.q = @"mimeType='image/jpeg'";
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

// Process the response and display output.
- (void)displayResultWithTicket:(GTLServiceTicket*)ticket
             finishedWithObject:(GTLDriveFileList*)response
                          error:(NSError*)error
{
    _files = response.files;
    if (error == nil) {
        NSMutableString* filesString = [[NSMutableString alloc] init];
        if (response.files.count > 0) {
            [filesString appendString:@"Files:\n"];
            for (GTLDriveFile* file in response.files) {
                [filesString appendFormat:@"%@ (%@)\n", file.name, file.webContentLink];
            }
        }
        else {
            [filesString appendString:@"No files found."];
        }
        //self.output.text = filesString;
    }
    else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }

    //
    ListTableViewController* controller = [[ListTableViewController alloc] init];
    controller.fileList = _files;
    controller.service = _service;
    [self.navigationController pushViewController:controller animated:YES];

    /*
    GTLServiceDrive *drive = self.service;
    GTLDriveFile *file = [_files objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/drive/v3/files/%@?alt=media",
                     file.identifier];
    GTMSessionFetcher *fetcher = [drive.fetcherService fetcherWithURLString:url];
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSLog(@"Retrieved file content");
            // Do something with data
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
*/
}

// Creates the auth controller for authorizing access to Drive API.
- (GTMOAuth2ViewControllerTouch*)createAuthController
{
    GTMOAuth2ViewControllerTouch* authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray* scopes = [NSArray arrayWithObjects:kGTLAuthScopeDrive, kGTLAuthScopeDriveFile, nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
           initWithScope:[scopes componentsJoinedByString:@" "]
                clientID:kClientID
            clientSecret:nil
        keychainItemName:kKeychainItemName
                delegate:self
        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and update the Drive API
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch*)viewController
      finishedWithAuth:(GTMOAuth2Authentication*)authResult
                 error:(NSError*)error
{
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self fetchFiles];
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString*)title message:(NSString*)message
{
    UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction* action) {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)fetchImagesButtonTaped:(id)sender
{
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        [self presentViewController:[self createAuthController] animated:YES completion:nil];
    }
    else {
        [self fetchFiles];
    }
}

@end
