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

@interface IntroVC ()

@property (weak, nonatomic) IBOutlet UIButton *practiceButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [Colorscheme darkPurpleColor];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    
    [self.practiceButton setTitle:@"Practice" forState:UIControlStateNormal];
    [self.practiceButton setTitleColor:[Colorscheme lightGrayColor] forState:UIControlStateNormal];
    self.practiceButton.backgroundColor = [Colorscheme blackPurpleColor];
    [self.practiceButton addTarget:self action:@selector(actOpenPractice) forControlEvents:UIControlEventTouchUpInside];
    
    self.practiceButton.titleLabel.font =
    self.playButton.titleLabel.font     = [UIFont fontWithName:@"Fabada" size:44];
    [self.playButton setTitleColor:[Colorscheme lightGrayColor] forState:UIControlStateNormal];
    self.playButton.backgroundColor = [Colorscheme blackPurpleColor];
    [self.playButton addTarget:self action:@selector(actOpenPlay) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)actOpenPractice
{
    GameVC *gameVC = [[GameVC alloc] init];
    [self presentViewController:gameVC animated:YES completion:nil];
}

- (void)actOpenPlay
{
    GameVC *gameVC = [[GameVC alloc] init];
    [self presentViewController:gameVC animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
