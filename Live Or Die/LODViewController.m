//
//  LODViewController.m
//  Live Or Die
//
//  Created by Vladimir Vinnik on 03.03.14.
//  Copyright (c) 2014 indeed!. All rights reserved.
//

#import "LODViewController.h"
#import "LODMyScene.h"
#import "LODStartGame.h"

@implementation LODViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // Create and configure the scene.
    SKScene * scene = [LODStartGame sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
