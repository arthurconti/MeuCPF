//
//  BarcodeViewController.h
//  MeuCPF
//
//  Created by Arthur Conti on 25/02/14.
//  Copyright (c) 2014 Arthur Conti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "GADBannerViewDelegate.h"
#import "GAITrackedViewController.h"

@class GADBannerView;
@class GADRequest;

@interface BarcodeViewController : GAITrackedViewController <GADBannerViewDelegate,ADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *adBanner;
@property  NSInteger index;

- (GADRequest *)request;


@end
