//
//  GameScene.h
//  skbn
//
//  Created by roikawa on 13/05/26.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "GameConfig.h"

@class SneakyJoystick;
//@class SneakyButton;

typedef enum
{
	GameSceneLayerTagGame = 1,
	GameSceneLayerTagInput,
    GameSceneNodeTagTreasureSpriteBatch,
    ControlUITagGame,
    WallTag,
	
} GameSceneLayerTags;

typedef enum
{
    up = 1,
    right,
    down,
    left,
} keyDirection;

// GameScene
@interface GameScene : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCSprite* atlasImg;
    SneakyJoystick *leftJoystick;
    
    CCSpriteBatchNode* spriteBatch;
    
    CCMenuItemImage* btn_u;
    CCMenuItemImage* btn_r;
    CCMenuItemImage* btn_d;
    CCMenuItemImage* btn_l;
    
    //現在操作中のブロックを指すポインタ
    NSMutableArray* blockMap;
//    CCSprite* block_1;
//    CCSprite* block_2;
    
    int displayTime;
    ccTime lifeTime;
    
    float span; //オブジェクトの更新タイミング
    int timer_span;   //更新時間を早めるタイミング
}

// returns a CCScene that contains the GameScene as the only child
+(CCScene *) scene;
+(GameScene*) sharedGameScene;

@end
