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
#import "CCNode.h"

#import "GameConfig.h"
#import "Player.h"

typedef enum
{
	GameSceneLayerTagGame = 1,
	GameSceneLayerTagInput,
    GameSceneNodeTagTreasureSpriteBatch,
    ControlUITagGame,
    WallTag,
    BlockTag,
	
} GameSceneLayerTags;

typedef enum
{
    UP = 1,
    RIGHT,
    DOWN,
    LEFT,
    NOP,
} keyDirection;

// GameScene
@interface GameScene : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCSprite* atlasImg;
    
    CCSpriteBatchNode* spriteBatch;
    
    CCMenuItemImage* btn_u;
    CCMenuItemImage* btn_r;
    CCMenuItemImage* btn_d;
    CCMenuItemImage* btn_l;
    
    CCSpriteBatchNode* wallList;  //壁
    NSMutableArray* map;   //描画マップ
    
    //現在操作中のブロックを指すポインタ
    Player* activeBlock;
    
    int displayTime;
    ccTime lifeTime;
    
    float span; //オブジェクトの更新タイミング
    int timer_span;   //更新時間を早めるタイミング
}

// returns a CCScene that contains the GameScene as the only child
+(CCScene *) scene;
+(GameScene*) sharedGameScene;

@property (atomic,retain)Player* activeBlock_;
@property (atomic,retain)CCSpriteBatchNode* wallList_;
@property (atomic,retain)NSMutableArray* map_;

@end
