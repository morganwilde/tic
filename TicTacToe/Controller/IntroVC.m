//
//  IntroVC.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "IntroVC.h"
#import "GameVC.h"
#import "Colorscheme.h"
#import "NSString+FontAwesome.h"

@interface IntroVC ()
@property (nonatomic, weak) IBOutlet UILabel *singlePlayerLabel;
@property (nonatomic, weak) IBOutlet UIButton *singlePlayerButton;

@property (nonatomic, weak) IBOutlet UILabel *multiPlayerLabel;
@property (nonatomic, weak) IBOutlet UIButton *multiPlayerButton;
@end

@implementation IntroVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAesthetics];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.singlePlayerLabel.alpha = 0;
    self.multiPlayerLabel.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:1.0 animations:^{
        self.singlePlayerLabel.alpha = 1;
        self.multiPlayerLabel.alpha = 1;
    }];
}

- (void)setupAesthetics
{
    [self.view setBackgroundColor:[Colorscheme darkPurpleColor]];
    
    NSInteger size = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 300 : 100;
    
    self.singlePlayerLabel.textColor = [Colorscheme brightGreenColor];
    self.singlePlayerLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:size];
    self.singlePlayerLabel.text = [NSString fontAwesomeIconStringForEnum:FAUser];
    
    self.multiPlayerLabel.textColor = [Colorscheme brightYellowColor];
    self.multiPlayerLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:size];
    self.multiPlayerLabel.text = [NSString fontAwesomeIconStringForEnum:FAUsers];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        CGRect newSingleLabelFrame = self.singlePlayerLabel.frame;
        newSingleLabelFrame.size.height = screenRect.size.height / 2;
        NSLog(@"Frame: %@", NSStringFromCGRect(newSingleLabelFrame));
        self.singlePlayerLabel.frame = newSingleLabelFrame;
        self.singlePlayerButton.frame = newSingleLabelFrame;
        
        CGRect newMultiLabelFrame = self.multiPlayerLabel.frame;
        newMultiLabelFrame.origin.y = screenRect.size.height / 2;
        newMultiLabelFrame.size.height = screenRect.size.height / 2;
        self.multiPlayerLabel.frame = newMultiLabelFrame;
        self.multiPlayerButton.frame = newMultiLabelFrame;
    }
}

#pragma mark - Actions
- (IBAction)singlePlayerButtonTouchDown:(id)sender
{

}

- (IBAction)singlePlayerButtonTouchUp:(id)sender
{
    
}

- (IBAction)multiPlayerButtonTouchDown:(id)sender
{
    
}

- (IBAction)multiPlayerButtonTouchUp:(id)sender
{
    
}


- (IBAction)singlePlayerButtonPressed:(id)sender
{
    GameVC *game = [self.storyboard instantiateViewControllerWithIdentifier:@"GameVC"];
    game.isMultiplayer = NO;
    [self.navigationController pushViewController:game animated:NO];
}

- (IBAction)multiPlayerButtonPressed:(id)sender
{
    GameVC *game = [self.storyboard instantiateViewControllerWithIdentifier:@"GameVC"];
    game.isMultiplayer = YES;
    [self.navigationController pushViewController:game animated:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
