//
//  PhotoViewController.m
//  GoogleDrivePOC
//
//  Created by Rupak Parikh on 16/07/16.
//  Copyright © 2016 Avira Operations GmbH & Co. KG. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView* imageview;

@end

@implementation PhotoViewController
@synthesize image;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageview.image = self.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
