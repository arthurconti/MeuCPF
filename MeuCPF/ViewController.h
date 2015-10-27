//
//  ViewController.h
//  MeuCPF
//
//  Created by Arthur Conti on 13/02/14.
//  Copyright (c) 2014 Arthur Conti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerViewDelegate.h"
#import "GAITrackedViewController.h"

@class GADBannerView;
@class GADRequest;

@interface ViewController :  GAITrackedViewController <UITableViewDelegate, UITableViewDataSource,GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *adBanner;

- (GADRequest *)request;



@end
