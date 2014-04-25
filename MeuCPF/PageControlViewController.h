//
//  PageControlViewController.h
//  Meu CPF
//
//  Created by Arthur Conti on 22/04/14.
//  Copyright (c) 2014 Arthur Conti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface PageControlViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;
- (IBAction)jumpOver:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
