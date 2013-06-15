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
//#import "BlockStateObject.h"

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
    ROT_LEFT,
    ROT_RIGHT,
    NOP,
} keyDirection;

// GameScene
@interface GameScene : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCSprite* atlasImg;
    
    CCSpriteBatchNode* spriteBatch;
    
    int map_offset_x;
    int map_offset_y;
    
    //操作UI
    //コントロールパネル
    CCMenuItemImage* btn_u;
    CCMenuItemImage* btn_r;
    CCMenuItemImage* btn_d;
    CCMenuItemImage* btn_l;
    
    //回転ボタン
    CCMenuItemImage* btn_a;
    CCMenuItemImage* btn_b;
    
    CCSpriteBatchNode* wallList;  //壁
    NSMutableArray* map;   //描画マップ
    
    //現在操作中のブロックを指すポインタ
//    BlockStateObject* activeBlock;
//    BlockStateObject* activeBlock2;
    Player* activeBlock;
    Player* activeBlock2;
    
    CCSprite* tile[MAP_HEIGHT][MAP_WIDTH];
    
    int displayTime;
    ccTime lifeTime;
    
    float span; //オブジェクトの更新タイミング
    int timer_span;   //更新時間を早めるタイミング
    int block_range;    //ブロックの種類数
}

// returns a CCScene that contains the GameScene as the only child
+(CCScene *) scene;
+(GameScene*) sharedGameScene;

@property (nonatomic)int map_offset_x_;
@property (nonatomic)int map_offset_y_;
@property (nonatomic)int block_range_;
@property (atomic,retain)Player* activeBlock_;
@property (atomic,retain)Player* activeBlock2_;
@property (atomic,retain)CCSpriteBatchNode* wallList_;
@property (atomic,retain)NSMutableArray* map_;
@property (atomic,retain)CCSprite* tile_;

@end
