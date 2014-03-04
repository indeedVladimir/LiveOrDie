//
//  LODGameOver.m
//  Live Or Die
//
//  Created by Vladimir Vinnik on 04.03.14.
//  Copyright (c) 2014 indeed!. All rights reserved.
//

#import "LODGameOver.h"

#define POSITION_OF_RECORD 1.8
#define POSITION_OF_MAX_SCORE 2.3
#define POSITION_OF_NOW_SCORE 2
#define POSITION_OF_OK_BUTTON 2.6

@implementation LODGameOver

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        //Set color of background
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        //Checking of a record, and show message
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"nowKilled"] > [[NSUserDefaults standardUserDefaults] integerForKey:@"maxKilled"]) {
            [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"nowKilled"] forKey:@"maxKilled"];
            _record = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
            _record.text = @"Your are set new record!";
            _record.fontSize = 16;
            _record.fontColor = [SKColor redColor];
            _record.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / POSITION_OF_RECORD);
            [self addChild:_record];
        }
        
        //Show text now killed zombies
        _nowKilled = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        _nowKilled.text = [NSString stringWithFormat:@"Now killed: %d", [[NSUserDefaults standardUserDefaults] integerForKey:@"nowKilled"]];
        _nowKilled.fontSize = 12;
        _nowKilled.fontColor = [SKColor blackColor];
        _nowKilled.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / POSITION_OF_NOW_SCORE);
        [self addChild:_nowKilled];
        
        //Show text max killed zombies
        _maxKilled = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        _maxKilled.text = [NSString stringWithFormat:@"Max killed: %d", [[NSUserDefaults standardUserDefaults] integerForKey:@"maxKilled"]];
        _maxKilled.fontSize = 12;
        _maxKilled.fontColor = [SKColor blackColor];
        _maxKilled.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / POSITION_OF_MAX_SCORE);
        [self addChild:_maxKilled];
        
        //Show button
        _okButton = [SKSpriteNode spriteNodeWithImageNamed:@"nextButton"];
        _okButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / POSITION_OF_OK_BUTTON);
        _okButton.size = CGSizeMake(50, 30);
        [self addChild:_okButton];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if ([_okButton containsPoint:location])
    {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene *startGame = [[LODStartGame alloc] initWithSize:self.size];
        [self.view presentScene:startGame transition:reveal];
    }
}


@end
