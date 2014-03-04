//
//  LODStartGame.m
//  Live Or Die
//
//  Created by Vladimir Vinnik on 04.03.14.
//  Copyright (c) 2014 indeed!. All rights reserved.
//

#import "LODStartGame.h"

#define POSITION_OF_LOGO 1.8
#define POSITION_OF_BUTTON 2.2

@implementation LODStartGame

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        //Set color of background
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        //Set logo
        _logoGame = [SKSpriteNode spriteNodeWithImageNamed:@"GameText"];
        _logoGame.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / POSITION_OF_LOGO);
        _logoGame.size = CGSizeMake(100, 50);
        [self addChild:_logoGame];
        
        //Set button start
        _buttonStart = [SKSpriteNode spriteNodeWithImageNamed:@"PlayButton"];
        _buttonStart.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / POSITION_OF_BUTTON);
        _buttonStart.size = CGSizeMake(50, 40);
        [self addChild:_buttonStart];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if ([_buttonStart containsPoint:location])
    {
        // Configure the view.
        SKView * skView = (SKView *)self.view;
        // Create and configure the scene.
        SKScene * scene = [LODMyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [skView presentScene:scene];
    }
}


@end
