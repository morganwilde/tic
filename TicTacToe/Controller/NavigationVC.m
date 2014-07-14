//
//  NavigationVC.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "NavigationVC.h"
/* Children VCs */
#import "IntroVC.h"
#import "GameVC.h"

@interface NavigationVC ()

@property (strong, nonatomic) IntroVC * introVC;
@property (strong, nonatomic) GameVC *  gameVC;

@end

@implementation NavigationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - Lazy initializers
- (IntroVC *)introVC
{
    if (!_introVC) {
        _introVC = [[IntroVC alloc] init];
    }
    return _introVC;
}
- (GameVC *)gameVC
{
    if (!_gameVC) {
        _gameVC = [[GameVC alloc] init];
    }
    return _gameVC;
}

@end
