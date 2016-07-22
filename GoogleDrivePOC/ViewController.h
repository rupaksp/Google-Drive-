//
//  ViewController.h
//  GoogleDrivePOC
//
//  Created by Rupak Parikh on 16/07/16.
//  Copyright © 2016 Avira Operations GmbH & Co. KG. All rights reserved.
//

#import "GTLDrive.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import <UIKit/UIKit.h>
@interface ViewController : UIViewController
@property (nonatomic, strong) GTLServiceDrive* service;
@property (nonatomic, strong) UITextView* output;
@property (nonatomic, strong) NSMutableArray* files;
@end
