//
//  LODMyScene.m
//  Live Or Die
//
//  Created by Vladimir Vinnik on 03.03.14.
//  Copyright (c) 2014 indeed!. All rights reserved.
//

#import "LODMyScene.h"

#pragma mark Shot

#define SPEED_OF_ZOMBIE 10
#define VELOCITY_OF_BULLET 480

static const uint32_t bulletCategory = 0x1 << 0;
static const uint32_t playerCategory = 0x1 << 1;
static const uint32_t zombieCategory = 0x1 << 2;

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

@implementation LODMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        //Set color of background
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        //Set gravity
        self.physicsWorld.gravity = CGVectorMake(0, 0.0);
        self.physicsWorld.contactDelegate = self;
        
        //Set player
        [self setPlayerToFrame];
        
        //Set text;
        _labelKilledZombie = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        _labelKilledZombie.text = @"Score: 0";
        _labelKilledZombie.fontSize = 12;
        _labelKilledZombie.fontColor = [SKColor blackColor];
        _labelKilledZombie.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 3.5);
        [self addChild:_labelKilledZombie];
        
        countOfKilledZombie = 0;
    }
    return self;
}

-(void)setPlayerToFrame{
    //Set player stat
    _player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    _player.size = CGSizeMake(15, 30);
    _player.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    //Set physics for player
    _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.size];
    _player.physicsBody.categoryBitMask = playerCategory;
    _player.physicsBody.collisionBitMask = zombieCategory;
    _player.physicsBody.contactTestBitMask = zombieCategory;
    
    //Add player to frame
    [self addChild:_player];
}

-(void)addZombie{
    //Set up position of zombie
    int minX;
    int minY;
    int maxX;
    int maxY;
    int actualX;
    int actualY;
    
    //Set x
    int random = arc4random()%2;
    if (random == 0) {
        minX = self.frame.size.width;
        maxX = minX + 40;
        actualX = (arc4random() % minX) + maxX;
    }
    else {
        actualX = (arc4random() % 40) * -1;
    }
    
    //Set y
    random = arc4random()%2;
    if (random == 0) {
        minY = self.frame.size.height;
        maxY = minY + 40;
        actualY = (arc4random() % minY) + maxY;
    }
    else {
        actualY = (arc4random() % 40) * -1;
    }
    
    //Set picture of Zombie
    random = arc4random()%2;
    if (random == 0) {
        _zombie = [SKSpriteNode spriteNodeWithImageNamed:@"zombie"];
    }
    else {
        _zombie = [SKSpriteNode spriteNodeWithImageNamed:@"coolzombie"];
    }
    
    //Set position and size of zombie;
    _zombie.position = CGPointMake(actualX, actualY);
    _zombie.size = CGSizeMake(15, 30);
    
    
    //Assigning contact and collision masks
    _zombie.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_zombie.size];
    _zombie.physicsBody.categoryBitMask = zombieCategory;
    _zombie.physicsBody.collisionBitMask = bulletCategory | zombieCategory;
    _zombie.physicsBody.contactTestBitMask = bulletCategory | zombieCategory;
    
    //Change zombie skin orientation
    if (_zombie.position.x > _player.position.x) {
        _zombie.xScale = -1.0;
    }
    
    //Action
    SKAction * actionMove = [SKAction moveTo:_player.position duration:SPEED_OF_ZOMBIE];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [_zombie runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    [self addChild:_zombie];
}

-(void)addBlood:(CGFloat)x andY:(CGFloat)y {
    //Chouse texture of blood
    int random = arc4random()% 4;
    if (random == 0) {
        _blood = [SKSpriteNode spriteNodeWithImageNamed:@"blood"];
    }
    else if (random == 1) {
        _blood = [SKSpriteNode spriteNodeWithImageNamed:@"blood1"];
    }
    else if (random == 2) {
        _blood = [SKSpriteNode spriteNodeWithImageNamed:@"blood2"];
    }
    else {
        _blood = [SKSpriteNode spriteNodeWithImageNamed:@"blood3"];
    }
    
    //Set stat of blood
    _blood.position = CGPointMake(x, y);
    _blood.size = CGSizeMake(20, 20);
    
    random = arc4random()% 2;
    if (random == 0) {
        _blood.xScale = -1.0;
    }
    else {
        _blood.xScale = 1.0;
    }
    
    random = arc4random()% 2;
    if (random == 0) {
        _blood.yScale = -1.0;
    }
    else {
        _blood.yScale = 1.0;
    }
    
    //Add blood to frame
    [self addChild:_blood];
}

-(void)addBullet:(CGPoint)location{
    //Initial of bullet
    _bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
    _bullet.size = CGSizeMake(5, 5);
    _bullet.position = _player.position;
    
    //Determine offset of location to projectile
    CGPoint offset = rwSub(location, _bullet.position);
    
    //Get the direction of where to shoot
    CGPoint direction = rwNormalize(offset);
    
    //Make it shoot far enough to be guaranteed off screen
    CGPoint shootAmount = rwMult(direction, 1000);
    
    //Add the shoot amount to the current position
    CGPoint realDest = rwAdd(shootAmount, self.bullet.position);
    
    //Assigning contact and collision masks
    _bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_bullet.size];
    _bullet.physicsBody.categoryBitMask = bulletCategory;
    _bullet.physicsBody.collisionBitMask = zombieCategory;
    _bullet.physicsBody.contactTestBitMask = zombieCategory;
    
    //Create the actions of bullet
    float realMoveDuration = self.frame.size.width / VELOCITY_OF_BULLET;
    SKAction *actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [_bullet runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    [self addChild:self.bullet];
}

#pragma mark Touch

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //Get location touches
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    //Change player skin orientation
    if (location.x < _player.position.x) {
        _player.xScale = -1.0;
    }
    else {
        _player.xScale = 1.0;
    }
    
    //Add bullet
    [self addBullet:location];
}

#pragma mark Update

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval) timeSinceLast{
    _lastSpawnTimeInterval += timeSinceLast;
    if (_lastSpawnTimeInterval > 1) {
        _lastSpawnTimeInterval = 0;
        [self addZombie];
    }
}

-(void)update:(NSTimeInterval)currentTime{
    CFTimeInterval timeSinceLast = currentTime - _lastSpawnTimeInterval;
    _lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
        _lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

#pragma mark Contact

- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & bulletCategory) != 0){
        [self bullet:(SKSpriteNode *)firstBody.node didCollideWithZombie:(SKSpriteNode *)secondBody.node];
    }
    if ((firstBody.categoryBitMask & playerCategory) != 0){
        [self player:(SKSpriteNode *)firstBody.node didCollideWithZombie:(SKSpriteNode *)secondBody.node];
    }
}

- (void)bullet:(SKSpriteNode *)bullet didCollideWithZombie:(SKSpriteNode *)zombie {
    [bullet removeFromParent];
    [zombie removeFromParent];
    
    [self addBlood:zombie.position.x andY:zombie.position.y];
    
    countOfKilledZombie++;
    _labelKilledZombie.text = [NSString stringWithFormat:@"Score: %d", countOfKilledZombie];
}

- (void)player:(SKSpriteNode *)player didCollideWithZombie:(SKSpriteNode *)zombie {
    [self saveResults];
    
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene *gameOver = [[LODGameOver alloc] initWithSize:self.size];
    [self.view presentScene:gameOver transition:reveal];
}

#pragma mark Save results

-(void)saveResults{
    [[NSUserDefaults standardUserDefaults] setInteger:countOfKilledZombie forKey:@"nowKilled"];
}

@end
