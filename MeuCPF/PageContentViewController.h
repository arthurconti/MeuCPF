//
//  PageContentViewController.h
//  Meu CPF
//
//  Created by Arthur Conti on 22/04/14.
//  Copyright (c) 2014 Arthur Conti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;




@end
