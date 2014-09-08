//
//  Tweak.xm
//  Faces
//  Add images to the passcode buttons.
//  
//  Created by Ben Rosen and CP Digital Darkroom on 09/06/2014
//  Copyright (c) 2014, Ben Rosen. All rights reserved.
//


#define kBundle [NSBundle bundleWithPath:@"/Library/PreferenceBundles/Faces.bundle"]
#define kSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/org.benrosen.facesprefs.plist"]
#define IS_NOT_IPAD UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad

NSMutableDictionary *prefs = nil;

@interface SBUIPasscodeLockNumberPad : UIView

+ (id)_buttonForCharacter:(int)checker;

@end

@interface UIImage (Private)

+ (UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;

@end

@interface TPRevealingRingView : UIView

@property(retain, nonatomic) UIColor *colorOutsideRing;
@property(retain, nonatomic) UIColor *colorInsideRing;

@end

@interface SBPasscodeNumberPadButton : UIView

@property(readonly, nonatomic) TPRevealingRingView *revealingRingView;
@property(retain, nonatomic) UIColor *color;

@end

@interface TPNumberPadButton : UIControl

@end

@interface TPPathView : UIView

- (void)setFillColor:(id)arg1;

@end

%hook TPNumberPad

- (id)initWithButtons:(NSArray *)arg1 {
	NSLog(@"[Faces] This could be the big deal!");
		if ([[prefs objectForKey:@"enabled"] boolValue]) {
			for (int i = 0; i <= 11; i++) {
				if (i != 9 && i != 11) {
					UIImageView *imageView = [[UIImageView alloc] init];
				        if ([prefs objectForKey:@"opacity"])
				        	imageView.alpha = [[prefs objectForKey:@"opacity"] floatValue];
				        else 
				        	imageView.alpha = 0.5;
				        if (IS_NOT_IPAD) {
				        	imageView.frame = CGRectMake(0, 0, 73, 73);
							imageView.center = CGPointMake(47.5, 44.5);
				        } else {
				        	imageView.frame = CGRectMake(0, 0, 77.5, 77.5);
							imageView.center = CGPointMake(53, 50.5);
				        }

				UIImage *imageToSet = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Faces/picture%i.png", i+1]];
				[imageView setImage:imageToSet];
				SBPasscodeNumberPadButton *numberButton = [arg1 objectAtIndex:i];
				TPRevealingRingView *ringView = numberButton.revealingRingView;
		   			imageView.layer.cornerRadius = imageView.frame.size.height / 2;
					imageView.layer.masksToBounds = YES;
					imageView.layer.borderWidth = 0;
				[ringView addSubview:imageView];
				[imageView release];
				}
			}
		}
	return %orig;
}

%end

void onceConstructor() {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {

    if (![[NSFileManager defaultManager]fileExistsAtPath:kSettingsPath]) {
    	UIAlertView *welcomeAlert = [[UIAlertView alloc] initWithTitle:@"Faces" message: @"Welcome to Faces! Please visit settings to start enjoying the tweak." delegate:nil cancelButtonTitle:@"Great!" otherButtonTitles:nil];
    	[welcomeAlert show];
    	[welcomeAlert release];
    }

    %orig;

}

%end

%ctor {
    
    onceConstructor();

    NSString* facesPath = @"/var/mobile/Library/";
	NSString *folderName = [facesPath stringByAppendingPathComponent:@"Faces"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
		if (![fileManager fileExistsAtPath:folderName]){
    		[fileManager createDirectoryAtPath:folderName
           					withIntermediateDirectories:YES
                            attributes:nil
                            error:&error];
}
        
}