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

@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *playMultiplayerButton;

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
    CGFloat width = self.view.bounds.size.width * 0.6;
    CGFloat height = self.view.bounds.size.width * 0.2;
    CGRect rect = CGRectMake(self.view.bounds.size.width/2.0 - width/2.0,
                             self.view.bounds.size.height/2.0 - height/2.0 - height/2.0 - 10,
                             width,
                             height);
    self.playButton = [[UIButton alloc] initWithFrame:rect];
    self.playButton.titleLabel.font = [UIFont fontWithName:@"Fabada" size:72];
    [self.playButton setTitle:@"Practice" forState:UIControlStateNormal];
    [self.playButton setTitleColor:[Colorscheme lightGrayColor] forState:UIControlStateNormal];
    self.playButton.backgroundColor = [Colorscheme blackPurpleColor];
    [self.playButton addTarget:self action:@selector(actOpenPractice) forControlEvents:UIControlEventTouchUpInside];
    
    self.playMultiplayerButton = [[UIButton alloc] initWithFrame:CGRectOffset(rect, 0, height + 10)];
    self.playMultiplayerButton.titleLabel.font = [UIFont fontWithName:@"Fabada" size:72];
    [self.playMultiplayerButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.playMultiplayerButton setTitleColor:[Colorscheme lightGrayColor] forState:UIControlStateNormal];
    self.playMultiplayerButton.backgroundColor = [Colorscheme blackPurpleColor];
    [self.playMultiplayerButton addTarget:self action:@selector(actOpenPlay) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.playMultiplayerButton];
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
