#import <Preferences/Preferences.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSSliderTableCell.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PSTableCell (Faces)
@property (nonatomic, retain) UIView *backgroundView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end

@interface PSListController (Faces)
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
-(UINavigationController*)navigationController;
@end


@interface FacesListController: PSListController

- (void)respring;
- (void)showCredits;

@end

@implementation FacesListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Faces" target:self] retain];
    }
    [self localizedSpecifiersWithSpecifiers:_specifiers];

    return _specifiers;
}

- (id)localizedSpecifiersWithSpecifiers:(NSArray *)specifiers {
    
    NSLog(@"localizedSpecifiersWithSpecifiers");
    for(PSSpecifier *curSpec in specifiers) {
        NSString *name = [curSpec name];
        if(name) {
            [curSpec setName:[[self bundle] localizedStringForKey:name value:name table:nil]];
        }
        NSString *footerText = [curSpec propertyForKey:@"footerText"];
        if(footerText)
            [curSpec setProperty:[[self bundle] localizedStringForKey:footerText value:footerText table:nil] forKey:@"footerText"];
        id titleDict = [curSpec titleDictionary];
        if(titleDict) {
            NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
            for(NSString *key in titleDict) {
                NSString *value = [titleDict objectForKey:key];
                [newTitles setObject:[[self bundle] localizedStringForKey:value value:value table:nil] forKey: key];
            }
            [curSpec setTitleDictionary:newTitles];
        }
    }
    return specifiers;
}

- (void)loadView {
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(tweetSP:)];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor grayColor];
}

- (void)respring {
    system("killall -9 SpringBoard");
}

- (void)showCredits {
    UIAlertView *credits = [[UIAlertView alloc] initWithTitle:@"Faces" message:@"@benrosen0 - Developer\n@CPDigiDarkroom - Developer\nThanks @krevony for the icon." delegate:nil cancelButtonTitle:@"Thanks!" otherButtonTitles:nil];
    [credits show];
    [credits release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.tintColor = [UIColor grayColor];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor grayColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.view.tintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;

}

- (void)tweetSP:(id)sender {
	TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
    [tweetController setInitialText:@"Just got the tweak #Faces, by @benrosen0 and @CPDigiDarkroom! I love it!"];
    [tweetController addImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Faces.bundle/mockup.png"]];
    [self.navigationController presentViewController:tweetController animated:YES completion:nil];
    [tweetController release];
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
        PSTableCell *cell = [super tableView:arg1 cellForRowAtIndexPath:arg2];

        ((UILabel *)cell.titleLabel).textColor = [UIColor grayColor];

    return cell;
}

- (void)dealloc{
    [super dealloc];
}

@end

@interface FacesCustomCell : PSTableCell {
	UILabel *tweakName;
    UILabel *devName1;
    UILabel *devName2;
}

@end

@implementation FacesCustomCell

- (id)initWithSpecifier:(PSSpecifier *)specifier
{
        self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
        if (self) {
        int width = [[UIScreen mainScreen] bounds].size.width;
        CGRect frame = CGRectMake(0, -10, width, 60);
        CGRect botFrame = CGRectMake(0, 20, width, 60);
        CGRect randFrame = CGRectMake(0, 40, width, 60);
 
        tweakName = [[UILabel alloc] initWithFrame:frame];
        [tweakName setNumberOfLines:1];
        tweakName.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:40];
        [tweakName setText:@"Faces"];
        [tweakName setBackgroundColor:[UIColor clearColor]];
        tweakName.textColor = [UIColor blackColor];
        tweakName.textAlignment = NSTextAlignmentCenter;

        devName1 = [[UILabel alloc] initWithFrame:botFrame];
        [devName1 setNumberOfLines:1];
        devName1.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
        [devName1 setText:@"Ben Rosen"];
        [devName1 setBackgroundColor:[UIColor clearColor]];
        devName1.textColor = [UIColor grayColor];
        devName1.textAlignment = NSTextAlignmentCenter;

        devName2 = [[UILabel alloc] initWithFrame:randFrame];
        [devName2 setNumberOfLines:1];
        devName2.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
        [devName2 setText:@"CP Digital Darkroom"];
        [devName2 setBackgroundColor:[UIColor clearColor]];
        devName2.textColor = [UIColor grayColor];
        devName2.textAlignment = NSTextAlignmentCenter;
 
        [self addSubview:tweakName];
        [self addSubview:devName1];
        [self addSubview:devName2];

        }
        return self;
}
 
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1
{
    return 110.f;
}

@end

@interface FacesChooseImagesListController : PSListController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)buttonOne;
- (void)buttonTwo;
- (void)buttonThree;
- (void)buttonFour;
- (void)buttonFive;
- (void)buttonSix;
- (void)buttonSeven;
- (void)buttonEight;
- (void)buttonNine;
- (void)buttonZero;

@end

@implementation FacesChooseImagesListController

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"FacesChooseImages" target:self] retain];
    }
    [self localizedSpecifiersWithSpecifiers:_specifiers];

    return _specifiers;
}

- (id)localizedSpecifiersWithSpecifiers:(NSArray *)specifiers {
    
    NSLog(@"localizedSpecifiersWithSpecifiers");
    for(PSSpecifier *curSpec in specifiers) {
        NSString *name = [curSpec name];
        if(name) {
            [curSpec setName:[[self bundle] localizedStringForKey:name value:name table:nil]];
        }
        NSString *footerText = [curSpec propertyForKey:@"footerText"];
        if(footerText)
            [curSpec setProperty:[[self bundle] localizedStringForKey:footerText value:footerText table:nil] forKey:@"footerText"];
        id titleDict = [curSpec titleDictionary];
        if(titleDict) {
            NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
            for(NSString *key in titleDict) {
                NSString *value = [titleDict objectForKey:key];
                [newTitles setObject:[[self bundle] localizedStringForKey:value value:value table:nil] forKey: key];
            }
            [curSpec setTitleDictionary:newTitles];
        }
    }
    return specifiers;
}

- (void)loadView {
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(tweetSP:)];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.tintColor = [UIColor grayColor];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor grayColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.view.tintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;

}

- (void)tweetSP:(id)sender {
    TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
    [tweetController setInitialText:@"Just got the tweak #Faces, by @benrosen0 and @CPDigiDarkroom! I love it!"];
    [tweetController addImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/Faces/mockup.png"]];
    [self.navigationController presentViewController:tweetController animated:YES completion:nil];
    [tweetController release];
}

int buttonNumber;

- (void)buttonOne {
    buttonNumber = 1;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];
}

- (void)buttonTwo {
    buttonNumber = 2;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];
}

- (void)buttonThree {
    buttonNumber = 3;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];
}

- (void)buttonFour {
    buttonNumber = 4;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];    
}

- (void)buttonFive {
    buttonNumber = 5;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];    
}

- (void)buttonSix {
    buttonNumber = 6;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];    
}

- (void)buttonSeven {
    buttonNumber = 7;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];    
}

- (void)buttonEight {
    buttonNumber = 8;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];    
}

- (void)buttonNine {
    buttonNumber = 9;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];    
}

- (void)buttonZero {
    buttonNumber = 11;
    UIAlertView *askImageType = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Do you want to take a photo or choose an existing photo?" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Take a photo", @"Choose an existing photo.", nil];
    [askImageType show];
    [askImageType release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;

    if (buttonIndex == 1) {
        NSLog(@"[Faces] Take a photo.");
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 2) {
        NSLog(@"[Faces] Choose a photo from photo library.");
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if (buttonIndex != 0) {
    [self.navigationController presentViewController:imagePicker animated:YES completion: nil];
    [imagePicker release];
} else {
    [imagePicker release];
}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"[Faces] The dictionary with photos that we've just recieved: %@", info);
    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%i.png", buttonNumber];
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(picture);
    [imageData writeToFile:path atomically:YES];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
        PSTableCell *cell = [super tableView:arg1 cellForRowAtIndexPath:arg2];

        ((UILabel *)cell.titleLabel).textColor = [UIColor grayColor];

    return cell;
}


@end

@interface FacesChooseImagesCustomCell : PSTableCell {
    UILabel *llLbl;
    UILabel *dLbl;
}

@end

@implementation FacesChooseImagesCustomCell

- (id)initWithSpecifier:(PSSpecifier *)specifier
{
        self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
        if (self) {

            int width = [[UIScreen mainScreen] bounds].size.width;
            CGRect frame = CGRectMake(0, -15, width, 60);
            CGRect botFrame = CGRectMake(0, 20, width, 60);
                
            llLbl = [[UILabel alloc] initWithFrame:frame];
            [llLbl setNumberOfLines:1];
            llLbl.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:40];
            [llLbl setText:@"Choose Images"];
            [llLbl setBackgroundColor:[UIColor clearColor]];
            llLbl.textColor = [UIColor blackColor];
            llLbl.textAlignment = NSTextAlignmentCenter;

            dLbl = [[UILabel alloc] initWithFrame:botFrame];
            [dLbl setNumberOfLines:1];
            dLbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
            [dLbl setText:@"Select the images for the buttons."];
            [dLbl setBackgroundColor:[UIColor clearColor]];
            dLbl.textColor = [UIColor grayColor];
            dLbl.textAlignment = NSTextAlignmentCenter;

            [self addSubview:llLbl];
            [self addSubview:dLbl];
            [llLbl release];
            [dLbl release];

        }
        return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1
{
    return 80.f;
}


@end

@interface FacesSwitchCell : PSSwitchTableCell

@end

@implementation FacesSwitchCell

- (id)initWithStyle:(int)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)spec {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:spec]; 

    if (self) {
        [((UISwitch *)[self control]) setOnTintColor:[UIColor grayColor]];

    }
    return self;
}

@end

@interface FacesSliderCell : PSSliderTableCell <UIAlertViewDelegate, UITextFieldDelegate> {
  CGFloat minimumValue;
  CGFloat maximumValue;
}
-(void)presentPopup;
@end


@implementation FacesSliderCell
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:arg2 specifier:arg3];
  if (self) {
    CGRect frame = [self frame];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(frame.size.width-50,0,50,frame.size.height);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentPopup) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
  }
  return self;
}

-(void) presentPopup {
    NSString * name = self.specifier.name;
  maximumValue = [[self.specifier propertyForKey:@"max"] floatValue];
  minimumValue = [[self.specifier propertyForKey:@"min"] floatValue];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:name
                                                  message:[NSString stringWithFormat:@"Please enter a value between %i and %i.", (int)minimumValue, (int)maximumValue]
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Enter"
                        , nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  alert.tag = 342879;
  [alert show];
  [[alert textFieldAtIndex:0] setDelegate:self];
  [[alert textFieldAtIndex:0] resignFirstResponder];
  [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
  [[alert textFieldAtIndex:0] becomeFirstResponder];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 342879 && buttonIndex == 1) {
    CGFloat value = [[alertView textFieldAtIndex:0].text floatValue];
    if(value <= maximumValue && value >= minimumValue) {
      [PSRootController setPreferenceValue:[NSNumber numberWithFloat:value] specifier:self.specifier];
      [[NSUserDefaults standardUserDefaults] synchronize];
      UITableView * table = [self _tableView];
      PSListController* currentController = (PSListController*)table.delegate;
      [currentController reloadSpecifier:self.specifier];
    }
    else {

      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"Ensure you entered a valid value."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil
                            , nil];
      alert.tag = 85230234;
      [alert show];
    }
  }
  else if(alertView.tag == 85230234)
    [self presentPopup];
}

@end

@interface FacesSupportListController : PSListController <MFMailComposeViewControllerDelegate>

- (void)openBenTwitter;
- (void)openCarlosTwitter;
- (void)emailBR;

@end

@implementation FacesSupportListController

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"FacesSupport" target:self] retain];
    }
    [self localizedSpecifiersWithSpecifiers:_specifiers];

    return _specifiers;
}

- (id)localizedSpecifiersWithSpecifiers:(NSArray *)specifiers {
    
    NSLog(@"localizedSpecifiersWithSpecifiers");
    for(PSSpecifier *curSpec in specifiers) {
        NSString *name = [curSpec name];
        if(name) {
            [curSpec setName:[[self bundle] localizedStringForKey:name value:name table:nil]];
        }
        NSString *footerText = [curSpec propertyForKey:@"footerText"];
        if(footerText)
            [curSpec setProperty:[[self bundle] localizedStringForKey:footerText value:footerText table:nil] forKey:@"footerText"];
        id titleDict = [curSpec titleDictionary];
        if(titleDict) {
            NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
            for(NSString *key in titleDict) {
                NSString *value = [titleDict objectForKey:key];
                [newTitles setObject:[[self bundle] localizedStringForKey:value value:value table:nil] forKey: key];
            }
            [curSpec setTitleDictionary:newTitles];
        }
    }
    return specifiers;
}

- (void)loadView {
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(tweetSP:)];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.tintColor = [UIColor grayColor];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor grayColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.view.tintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;

}
- (void)tweetSP:(id)sender {
    TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
    [tweetController setInitialText:@"Just got the tweak #Faces, by @benrosen0 and @CPDigiDarkroom! I love it!"];
    [tweetController addImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Library/Faces/mockup.png"]];
    [self.navigationController presentViewController:tweetController animated:YES completion:nil];
    [tweetController release];
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
        PSTableCell *cell = [super tableView:arg1 cellForRowAtIndexPath:arg2];

        ((UILabel *)cell.titleLabel).textColor = [UIColor grayColor];

    return cell;
}

- (void)openBenTwitter {
        NSString *user = @"benrosen0";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
    
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
    
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
    
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
    
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}
- (void)openCarlosTwitter {
        NSString *user = @"CPDigiDarkroom";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
    
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
    
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
    
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
    
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

- (void)emailBR {
    MFMailComposeViewController *emailBen = [[MFMailComposeViewController alloc] init];
    [emailBen setSubject:@"Faces Support"];
    [emailBen setToRecipients:[NSArray arrayWithObjects:@"benrosen78@gmail.com", nil]];
    [emailBen addAttachmentData:[NSData dataWithContentsOfFile:@"/var/mobile//Library/Preferences/org.benrosen.facesprefs.plist"] mimeType:@"application/xml" fileName:@"Prefs.plist"];
    system("/usr/bin/dpkg -l >/tmp/dpkgl.log");
    [emailBen addAttachmentData:[NSData dataWithContentsOfFile:@"/tmp/dpkgl.log"] mimeType:@"text/plain" fileName:@"dpkgl.txt"];
    [self.navigationController presentViewController:emailBen animated:YES completion:nil];
    emailBen.mailComposeDelegate = self;
    [emailBen release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated: YES completion: nil];
}

@end

@interface FacesSupportCustomCell : PSTableCell {
    UILabel *llLbl;
    UILabel *dLbl;
}

@end

@implementation FacesSupportCustomCell

- (id)initWithSpecifier:(PSSpecifier *)specifier
{
        self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
        if (self) {

            int width = [[UIScreen mainScreen] bounds].size.width;
            CGRect frame = CGRectMake(0, -15, width, 60);
            CGRect botFrame = CGRectMake(0, 20, width, 60);

            llLbl = [[UILabel alloc] initWithFrame:frame];
            [llLbl setNumberOfLines:1];
            llLbl.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:40];
            [llLbl setText:@"Support"];
            [llLbl setBackgroundColor:[UIColor clearColor]];
            llLbl.textColor = [UIColor blackColor];
            llLbl.textAlignment = NSTextAlignmentCenter;

            dLbl = [[UILabel alloc] initWithFrame:botFrame];
            [dLbl setNumberOfLines:1];
            dLbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
            [dLbl setText:@"Contact the developers"];
            [dLbl setBackgroundColor:[UIColor clearColor]];
            dLbl.textColor = [UIColor grayColor];
            dLbl.textAlignment = NSTextAlignmentCenter;

            [self addSubview:llLbl];
            [self addSubview:dLbl];
            [llLbl release];
            [dLbl release];

        }
        return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1
{
    return 80.f;
}


@end