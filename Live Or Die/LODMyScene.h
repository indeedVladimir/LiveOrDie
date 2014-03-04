//
//  LODMyScene.h
//  Live Or Die
//

//  Copyright (c) 2014 indeed!. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LODGameOver.h"

@interface LODMyScene : SKScene <SKPhysicsContactDelegate> {
    NSInteger countOfKilledZombie;
}

@property (nonatomic) SKSpriteNode *player;
@property (nonatomic) SKSpriteNode *zombie;

@property (nonatomic) SKSpriteNode *blood;
@property (nonatomic) SKSpriteNode *bullet;

@property (nonatomic) SKLabelNode *labelKilledZombie;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@end
