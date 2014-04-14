//
//  BarcodeViewController.m
//  MeuCPF
//
//  Created by Arthur Conti on 25/02/14.
//  Copyright (c) 2014 Arthur Conti. All rights reserved.
//

#import "BarcodeViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "ZXingObjC.h"

@interface BarcodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *myNavBar;
@property (strong, nonatomic) NSMutableArray *cpfs;
@property (strong, nonatomic) NSMutableArray *barImgs;
@property (weak, nonatomic) IBOutlet UILabel *lblBar;
@property (weak, nonatomic) IBOutlet UILabel *lblCPF;

@end

@implementation BarcodeViewController

@synthesize index;

- (NSMutableArray *) barImgs{
    if(!_barImgs) _barImgs = [[NSMutableArray alloc] init];
    return _barImgs;
}

- (IBAction)deleteCPF:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Apagar CPF"
                                                    message:@"Tem certeza que deseja apagar esse CPF?"
                                                   delegate:self
                                          cancelButtonTitle:@"Não"
                                          otherButtonTitles:@"Sim", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex!=0){
        [self.cpfs removeObject:[self.cpfs objectAtIndex:index]];
        [self.barImgs removeObject:[self.barImgs objectAtIndex:index]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.cpfs forKey:@"CPFS_RECORDED"];
        [defaults setObject:self.barImgs forKey:@"CPF_IMAGES"];
        [defaults synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.cpfs = nil;
    NSArray *tempArray = [defaults objectForKey:@"CPFS_RECORDED"];
    NSArray *temp2Array = [defaults objectForKey:@"CPF_IMAGES"];
    
    if (tempArray) {
        self.cpfs = [tempArray mutableCopy];
    } else {
        self.cpfs = [[NSMutableArray alloc] init];
    }
    
    if(temp2Array){
        self.barImgs = [temp2Array mutableCopy];
    }
    else {
        self.barImgs = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    if(self.barImgs.count>0){
        if(self.barImgs.count>self.index){
            //_imgBar.image = [UIImage imageWithData:[self.barImgs objectAtIndex:self.index]];
        }
    }
    
    NSError* error = nil;
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:[self.cpfs objectAtIndex:self.index]
                                  format:kBarcodeFormatCodabar
                                   width:self.view.bounds.size.width
                                  height:self.view.bounds.size.height/3
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        self.imgBar.image = [[UIImage alloc] initWithCGImage:image];
        self.lblCPF.text = [self formatCPF:[self.cpfs objectAtIndex:self.index]];
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString* errorMessage = [error localizedDescription];
    }
    
//    ---IMPLEMENTING VIA FONT BARCODE-----
    
//    self.lblBar.font = [UIFont fontWithName:@"IDAutomationHC39M" size:22.0];
//    self.lblBar.text = [NSString stringWithFormat:@"(%@)",[self.cpfs objectAtIndex:self.index]];
    
    
	// Do any additional setup after loading the view.
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0,
                                 self.view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.adBanner.adUnitID = @"ca-app-pub-5533659730176533/4211843001";
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self request]];
    
    UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteCPF:)];
    [btnDelete setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = btnDelete;
    
    [[UIScreen mainScreen] setBrightness: 1.0];
}

- (NSString *) formatCPF: (NSString *) cpf{
    NSString *cpfFormatado = [NSString stringWithFormat:@"%@.%@.%@-%@",[cpf substringWithRange:NSMakeRange(0, 3)],[cpf substringWithRange:NSMakeRange(3,3)],[cpf substringWithRange:NSMakeRange(6, 3)],[cpf substringWithRange:NSMakeRange(9, 2)]];
    
    return cpfFormatado;
}

- (void)dealloc {
    _adBanner.delegate = nil;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID
                            ];
    return request;
}

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) bannerViewDidLoadAd:(ADBannerView *)banner{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1];
//    [banner setAlpha:1];
//    [UIView commitAnimations];
//}
//
//-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1];
//    [banner setAlpha:0];
//    [UIView commitAnimations];
//}

@end
