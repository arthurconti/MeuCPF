//
//  ViewController.h
//  MeuCPF
//
//  Created by Arthur Conti on 13/02/14.
//  Copyright (c) 2014 Arthur Conti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "GADBannerViewDelegate.h"

@class GADBannerView;
@class GADRequest;

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,ADBannerViewDelegate, GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *adBanner;

- (GADRequest *)request;



@end
