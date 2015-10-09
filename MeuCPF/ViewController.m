//
//  ViewController.m
//  MeuCPF
//
//  Created by Arthur Conti on 13/02/14.
//  Copyright (c) 2014 Arthur Conti. All rights reserved.
//

#import "ViewController.h"
#import "BarcodeViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "CPF.h"

@interface ViewController ()
@property int alertType;
@property (nonatomic, strong) NSMutableArray *cpfs;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblVazio;
@property (weak, nonatomic) IBOutlet UILabel *lblCadastrados;
@property NSInteger index;
@property UITextField *txtCPF;
@property UITextField *txtName;
@property (nonatomic, strong) UIAlertView *alertview;
@property (strong,nonatomic) NSString *cpfTyped;

@end


@implementation ViewController

const int MAXLENGTHCPF = 11;

- (NSMutableArray *) cpfs{
    if(!_cpfs) _cpfs = [[NSMutableArray alloc] init];
    return _cpfs;
}


-(void) viewDidLoad{
    [self loadAds];
    
    //UIImage *image = [UIImage imageNamed:@"lock.png"];
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    //button.frame = CGRectMake(0 ,0,20,20);
    //UIBarButtonItem *btnLock = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnAdd, btnLock, nil]];
    
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCPF:)];
    [btnAdd setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = btnAdd;
}

- (void)dealloc {
    _adBanner.delegate = nil;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void) addDeleteButton{
    UIBarButtonItem *btnDeleteAll = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeAll:)];
    [btnDeleteAll setTintColor:[UIColor whiteColor]];
    
    if(self.cpfs.count>0)
        self.navigationItem.leftBarButtonItem = btnDeleteAll;
    else
        self.navigationItem.leftBarButtonItem = nil;
}

- (void) loadAds{
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"CPFs Screen";
    
    NSData *cpfData = [[NSUserDefaults standardUserDefaults] objectForKey:@"CPFS_LIST_RECORDED"];
    NSArray *tempArray = [NSKeyedUnarchiver unarchiveObjectWithData:cpfData];
    
    if(tempArray){
        self.cpfs = [tempArray mutableCopy];
    }
    else{
        self.cpfs = [[NSMutableArray alloc]init];
    }
    
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.view) {
        [self updateUI];
    }
}

- (void) updateUI{
    [self.myTableView reloadData];
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    if([self.cpfs count]>0){
        self.myTableView.hidden=false;
        self.lblCadastrados.hidden=false;
        self.lblVazio.hidden = true;
    }
    else{
        self.myTableView.hidden=true;
        self.lblCadastrados.hidden=true;
        self.lblVazio.hidden = false;
    }
    
    [self addDeleteButton];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self.txtCPF.text length] >= MAXLENGTHCPF) {
        self.txtCPF.text = [textField.text substringToIndex:MAXLENGTHCPF-1];
        return NO;
    }
    return YES;
}

//Plus button method
- (IBAction)addCPF:(id)sender {
    [self showAlertView:5 withText:nil];
}

//Trash button all method
- (IBAction)removeAll:(id)sender {
    [self showAlertView:6 withText:nil];
}


//Show Alert view Switch

- (void) showAlertView : (int) tipo withText:(NSString *) text{
    NSString *title;
    NSString *message;
    NSString *canceltitle=nil;
    NSString *oktitle;
    
    self.alertType = tipo;
    
    switch (tipo) {
        case 5:
            title = @"Cadastro de CPF";
            message = @"Digite seus dados abaixo";
            canceltitle = @"Cancelar";
            oktitle = @"Adicionar";
            break;
            
        case 6:
            title = @"Apagar Tudo?";
            message = @"Tem certeza que deseja apagar todos os CPFs?";
            canceltitle = @"Não";
            oktitle = @"Sim";
            break;
            
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:canceltitle
                                          otherButtonTitles:oktitle, nil];
    switch (tipo) {
        case 5:
            [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            self.txtName = [alert textFieldAtIndex:0];
            [self.txtName setPlaceholder:@"Digite seu nome"];
            [self.txtName setTextAlignment:NSTextAlignmentCenter];
            self.txtName.autocapitalizationType = UITextAutocapitalizationTypeWords;
            //            [self.txtCPF setTag:2];
            
            self.txtCPF =  [alert textFieldAtIndex:1];
            [self.txtCPF setSecureTextEntry:NO];
            [self.txtCPF setKeyboardType:UIKeyboardTypeNumberPad];
            [self.txtCPF setPlaceholder:@"000.000.000-00"];
            [self.txtCPF setTextAlignment:NSTextAlignmentCenter];
            [self.txtCPF setDelegate:self];
            //            [self.txtCPF setTag:2];
            [alert setTag:1];
            break;
            
        case 6:
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            break;
            
    }
    
    [alert show];
    
    //    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
    //        self.view.backgroundColor = [UIColor clearColor];
    //        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //        blurEffectView.frame = self.view.frame;
    //        [self.view addSubview:blurEffectView];
    //
    //        [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    //        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    //        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    //        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    //    }  else {
    //        self.view.backgroundColor = [UIColor blackColor];
    //    }
    
}

//Retrieve answer from AlertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *txtCpf;
    NSString *txtName;
    
    if(alertView.tag==1){
        txtName = [alertView textFieldAtIndex:0].text;
        txtCpf = [alertView textFieldAtIndex:1].text;
    }
    
    switch (self.alertType) {
            
        case 5:
            if(buttonIndex!=0){
                if([self validateCPFWithNSString:txtCpf]){
                    if([self validateDuplicatedCPF:txtCpf]){
                        [self addValidCPF:txtName :txtCpf];
                    }
                    else{
                        self.alertType=7;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CPF Duplicado!"
                                                                        message:@"Você já inseriu esse CPF!"
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"OK", nil];
                        [alert show];
                    }
                }
                else{
                    self.alertType=7;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CPF Inválido!"
                                                                    message:@"Insira somente CPFs válidos!"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                    [alert show];
                }
            }
            break;
            
        case 6:
            if(buttonIndex!=0){
                self.cpfs = nil;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"CPFS_LIST_RECORDED"];
                [defaults synchronize];
            }
            break;
    }
    [self updateUI];
}

//add to arrays the valid CPF
- (void) addValidCPF:(NSString *) name :(NSString *) cpf{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CPF *myCpf = [[CPF alloc] init];
    myCpf.name = name;
    myCpf.cpf = cpf;
    [self.cpfs addObject:myCpf];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.cpfs];
    [defaults setObject:data forKey:@"CPFS_LIST_RECORDED"];
    [defaults synchronize];
}



//Creates tableview content
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.index = [indexPath row];
    [self performSegueWithIdentifier:@"LoadCPF" sender:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Cadastrados";
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"LoadCPF"]) {
        // Get destination view
        BarcodeViewController *bvc = [segue destinationViewController];
        
        // Pass the information to your destination view
        bvc.index = self.index;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cpfs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    CPF *cpfObject = [self.cpfs objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self formatCPF:cpfObject.cpf];
    cell.textLabel.text = cpfObject.name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

//check if CPF is valid
- (BOOL)validateCPFWithNSString:(NSString *)cpf {
    
    NSUInteger i, firstSum, secondSum, firstDigit, secondDigit, firstDigitCheck, secondDigitCheck;
    if(cpf == nil) return NO;
    
    if ([cpf length] != 11) return NO;
    if (([cpf isEqual:@"00000000000"]) || ([cpf isEqual:@"11111111111"]) || ([cpf isEqual:@"22222222222"])|| ([cpf isEqual:@"33333333333"])|| ([cpf isEqual:@"44444444444"])|| ([cpf isEqual:@"55555555555"])|| ([cpf isEqual:@"66666666666"])|| ([cpf isEqual:@"77777777777"])|| ([cpf isEqual:@"88888888888"])|| ([cpf isEqual:@"99999999999"])) return NO;
    
    firstSum = 0;
    for (i = 0; i <= 8; i++) {
        firstSum += [[cpf substringWithRange:NSMakeRange(i, 1)] intValue] * (10 - i);
    }
    
    if (firstSum % 11 < 2)
        firstDigit = 0;
    else
        firstDigit = 11 - (firstSum % 11);
    
    secondSum = 0;
    for (i = 0; i <= 9; i++) {
        secondSum = secondSum + [[cpf substringWithRange:NSMakeRange(i, 1)] intValue] * (11 - i);
    }
    
    if (secondSum % 11 < 2)
        secondDigit = 0;
    else
        secondDigit = 11 - (secondSum % 11);
    
    firstDigitCheck = [[cpf substringWithRange:NSMakeRange(9, 1)] intValue];
    secondDigitCheck = [[cpf substringWithRange:NSMakeRange(10, 1)] intValue];
    
    if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck))
        return YES;
    return NO;
}

- (BOOL)validateDuplicatedCPF:(NSString *) cpf{
    BOOL notfound = YES;
    if(self.cpfs.count>0){
        for(int i=0;i<self.cpfs.count;i++){
            CPF *cpfObject = [self.cpfs objectAtIndex:i];
            if([cpf isEqualToString:cpfObject.cpf]){
                notfound=NO;
                break;
            }
        }
    }
    return notfound;
}
//returns a formatted string of CPF
- (NSString *) formatCPF: (NSString *) cpf{
    NSString *cpfFormatado = [NSString stringWithFormat:@"%@.%@.%@-%@",[cpf substringWithRange:NSMakeRange(0, 3)],[cpf substringWithRange:NSMakeRange(3,3)],[cpf substringWithRange:NSMakeRange(6, 3)],[cpf substringWithRange:NSMakeRange(9, 2)]];
    
    NSLog(cpfFormatado);
    return cpfFormatado;
}


@end
