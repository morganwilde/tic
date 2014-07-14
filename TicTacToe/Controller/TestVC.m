//
//  TestVC.m
//  TicTacToe
//
//  Created by Morgan Wilde on 11/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "TestVC.h"
#import "../View/Colorscheme.h"
#import "../View/CharacterView.h"

@interface TestVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleMain;
@property (weak, nonatomic) IBOutlet UILabel *titleSub;
@property (nonatomic, strong) CharacterView *characterX;

@end

@implementation TestVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [Colorscheme chalkboardBlackColor];
    self.titleMain.textColor = [Colorscheme lightGrayColor];
    //self.label.textColor = [Colorscheme lightGrayColor];
    self.titleMain.font = [UIFont fontWithName:@"Stark" size:34];
    self.titleMain.font = [UIFont fontWithName:@"Folks-Normal" size:34];
    self.titleMain.font = [UIFont fontWithName:@"Folks-Bold" size:34];
    self.titleMain.font = [UIFont fontWithName:@"Fabada" size:72];
    
    self.titleSub.font = [UIFont fontWithName:@"GardensC" size:20];
    self.titleSub.textColor = [Colorscheme darkGrayColor];
    
    // Testing new UI
    self.characterX = [[CharacterView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.characterX.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:self.characterX];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
