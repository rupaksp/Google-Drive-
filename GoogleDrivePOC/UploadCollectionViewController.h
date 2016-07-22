//
//  UploadCollectionViewController.h
//  GoogleDrivePOC
//
//  Created by Rupak Parikh on 21/07/16.
//  Copyright © 2016 Avira Operations GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLDrive.h"
@interface UploadCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) GTLServiceDrive* service;

@end
