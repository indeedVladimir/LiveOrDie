//
//  LODGameOver.h
//  Live Or Die
//
//  Created by Vladimir Vinnik on 04.03.14.
//  Copyright (c) 2014 indeed!. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LODStartGame.h"

@interface LODGameOver : SKScene

@property (nonatomic) SKLabelNode *maxKilled;
@property (nonatomic) SKLabelNode *nowKilled;
@property (nonatomic) SKLabelNode *record;

@property (nonatomic) SKSpriteNode *okButton;

-(id)initWithSize:(CGSize)size;

@end
