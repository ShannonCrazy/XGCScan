//
//  XGCViewController.m
//  XGCScan
//
//  Created by ShannonCrazy on 04/24/2024.
//  Copyright (c) 2024 ShannonCrazy. All rights reserved.
//

#import "XGCViewController.h"
#import <XGCMain/XGCMainRoute.h>
#import <XGCScan/XGCScanRoute.h>

@interface XGCViewController ()

@end

@implementation XGCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.purpleColor;
    [XGCMainRoute registerRoute:[XGCScanRoute new]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [XGCMainRoute routeURL:[NSURL URLWithString:@"xinggc://XGCScan"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
