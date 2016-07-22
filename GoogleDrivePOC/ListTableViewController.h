//
//  ListTableViewController.h
//  GoogleDrivePOC
//
//  Created by Rupak Parikh on 16/07/16.
//  Copyright © 2016 Avira Operations GmbH & Co. KG. All rights reserved.
//

#import "GTLDrive.h"
#import <UIKit/UIKit.h>
@interface ListTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray* fileList;
@property (nonatomic, strong) GTLServiceDrive* service;

@end
