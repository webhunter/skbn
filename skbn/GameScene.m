//
//  GameScene.m
//  skbn
//
//  Created by roikawa on 13/05/26.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "GameScene.h"
#import "Player.h"
#import "GameConfig.h"
//#import "SneakyJoystick.h"
//#import "SneakyJoystickSkinnedJoystickExample.h"
//#import "SneakyJoystickSkinnedDPadExample.h"
//#import "SneakyButton.h"
//#import "SneakyButtonSkinnedBase.h"
//#import "ColoredCircleSprite.h"
#import "Wall.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - GameScene

// GameScene implementation
@implementation GameScene

@synthesize activeBlock_ = activeBlock;
@synthesize wallList_ = wallList;
@synthesize map_ = map;

static GameScene* instanceOfGameScene;
+(GameScene*) sharedGameScene
{
	NSAssert(instanceOfGameScene != nil, @"GameScene instance not yet initialized!");
	return instanceOfGameScene;
}

// Helper class method that creates a Scene with the GameScene as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
    [scene addChild:layer z:0 tag:GameSceneLayerTagGame];
//	InputLayer* inputLayer = [InputLayer node];
//	[scene addChild:inputLayer z:1 tag:GameSceneLayerTagInput];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        //@@@初期化処理
        span = 1;
        timer_span = 100;
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        //タッチイベント
        self.isTouchEnabled = YES;
        
        //atlas読み込み
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"atlas_1.plist"];
        [atlasImg initWithFile:@"atlas_1.png"];
        
        //操作UI描画
        
        //左
        btn_l = [CCMenuItemImage
                          itemFromNormalImage:@"gls_blue_up.png" selectedImage:@"gls_blue_down.png"
                                  target:self selector:@selector(controllerTapped:)];
        btn_l.position = ccp(screenSize.width/6, screenSize.height/4);
        
        float btnSizeWidth = btn_l.contentSize.width;
        float btnSizeHeight = btn_l.contentSize.height;
        
        //下
        btn_d = [CCMenuItemImage
                 itemFromNormalImage:@"gls_blue_up.png" selectedImage:@"gls_blue_down.png"
                 target:self selector:@selector(controllerTapped:)];
        btn_d.position = ccp(screenSize.width/6+btnSizeWidth/2, screenSize.height/4-btnSizeHeight);
        
        //右
        btn_r = [CCMenuItemImage
                                  itemFromNormalImage:@"gls_blue_up.png" selectedImage:@"gls_blue_down.png"
                                  target:self selector:@selector(controllerTapped:)];
        btn_r.position = ccp(screenSize.width/6+btnSizeWidth, screenSize.height/4);
        
        //上
        btn_u = [CCMenuItemImage
                 itemFromNormalImage:@"gls_blue_up.png" selectedImage:@"gls_blue_down.png"
                 target:self selector:@selector(controllerTapped:)];
        btn_u.position = ccp(screenSize.width/6+btnSizeWidth/2, screenSize.height/4+btnSizeHeight);
        
        //メニューに追加
        CCMenu *controlMenu = [CCMenu menuWithItems:btn_l,btn_d,btn_r,btn_u, nil];
        
        controlMenu.position = CGPointZero;
        [self addChild:controlMenu z:3 tag:ControlUITagGame];
        
        //マップ読み込み
        int stageNum = 1;
        map = [self loadMap:map :stageNum];
        
        //マップ描画
        wallList = [CCSpriteBatchNode batchNodeWithFile:@"atlas_1.png"];
        [self addChild:wallList z:0 tag:WallTag];
        
        NSString* point;
        for (int i=0; i<MAP_HEIGHT; i++){
            for (int j=0; j<MAP_WIDTH; j++){
                //マップから該当する座標のオブジェクト種類を取得する
                point = [map objectAtIndex:[self convertGridToMap:j :i]];
                
                //数値に変換
                int point_coord = [point intValue];
                
                if (point_coord == EMPTY) {   //何もない空間はエスケープ
                    continue;
                }
//                else if(point_coord>0 && point_coord<20){   //未来使用
//                    NSString* file = [NSString stringWithFormat:@"img_%02d.png",point_coord];
//                }
                else if (point_coord == WALL){  //壁
                    CCSpriteFrame* frm = [frameCache spriteFrameByName:@"img_20.png"];
                    
                    Wall* wall = [Wall initialize:frm];
                    wall.position = [self convertGridToCcp:j :i];
                    
                    [wallList addChild:wall z:0 tag:WallTag];
                }
            }
        }
                
        //ブロック生成
//        int grid_x_1 = 1;
//        int grid_y_1 = 0;
//        Player* block_1 = [Player initialize:grid_x_1 :grid_y_1];
//        block_1.position = [self convertGridToCcp:grid_x_1 :grid_y_1];
        
        activeBlock = [self createBlock];

        [self addChild:activeBlock z:0 tag:BlockTag];
        [self scheduleUpdate];
	}
	return self;
}

//ブロック生成処理
-(Player*)createBlock
{
    int grid_x_1 = 1;
    int grid_y_1 = 0;
    Player* block_1 = [Player initialize:grid_x_1 :grid_y_1];
    block_1.position = [self convertGridToCcp:grid_x_1 :grid_y_1];
    
    return block_1;
}

//座標変換(grid->map)
-(int)convertGridToMap:(int)grid_x :(int)grid_y
{
    return MAP_WIDTH * grid_y + grid_x;   //i回分WIDTHが回った
}

//座標変換(grid->ccp)
-(CGPoint)convertGridToCcp:(int)grid_x :(int)grid_y
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint pos = ccp(MAP_OFFSET_X + grid_x * SIZE_TILE, screenSize.height - (MAP_OFFSET_Y + grid_y * SIZE_TILE));
    return pos;
}

//座標変換(ccp->grid)
-(CGPoint)convertCcpToGrid:(int)pos_x :(int)pos_y
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    return CGPointMake((pos_x - MAP_OFFSET_X)/SIZE_TILE,(screenSize.height - pos_y - MAP_OFFSET_Y)/SIZE_TILE);
    
    //導出過程
//    pos_x = MAP_OFFSET_X + grid_x * SIZE_TILE;
//    grid_x = (pos_x - MAP_OFFSET_X)/SIZE_TILE;
//    
//    pos_y = screenSize.height - (MAP_OFFSET_Y + grid_y * SIZE_TILE);
//    grid_y = (screenSize.height - pos_y - MAP_OFFSET_Y)/SIZE_TILE;
}

//コントローラ
- (void)controllerTapped:(id)sender{
//    NSLog(@"sender:%d");
    
    CCMenuItemImage* btn = sender;
    int dir = NOP;
    
    if (btn.hash == btn_u.hash) {   //上
        dir = UP;
    }
    else if (btn.hash == btn_l.hash) {   //左
        dir = LEFT;
    }
    else if (btn.hash == btn_d.hash) {   //下
        dir = DOWN;
    }
    else if (btn.hash == btn_r.hash) {   //右
        dir = RIGHT;
    }
    
    //移動
    [self move:dir];
}

//移動メソッド
-(BOOL)move:(int)dir{
       
    //移動方向に向かって１グリッド分移動する
    int next_grid_x = activeBlock.grid_x_;
    int next_grid_y = activeBlock.grid_y_;
    
    //移動先を調査
    if (dir == LEFT){   //左
        next_grid_x -= 1;
        
        if ([self isEmptyBlock:next_grid_x :next_grid_y]) {
            activeBlock.grid_x_ = next_grid_x;
        }
    }
    else if (dir == RIGHT){ //右
        next_grid_x += 1;
        
        if ([self isEmptyBlock:next_grid_x :next_grid_y]) {
            activeBlock.grid_x_ = next_grid_x;
        }
    }
    else if (dir == DOWN) {  //下
        next_grid_y += 1;
        
        if ([self isEmptyBlock:next_grid_x :next_grid_y]) {
            activeBlock.grid_y_ = next_grid_y;
        }
        else{
            
            //移動できなくなった場合、マップを更新してNOを返す
            int replaceIdx = [self convertGridToMap:activeBlock.grid_x_ :activeBlock.grid_y_];
            NSString* setValue = [NSString stringWithFormat:@"%02d",BLOCK_STAY];
            
            [map replaceObjectAtIndex:replaceIdx withObject:setValue];
            return NO;
        }
    }
    
    activeBlock.position = [self convertGridToCcp:activeBlock.grid_x_ :activeBlock.grid_y_];
    return YES;
}

//指定した座標がEMPTYかどうかを調べる
-(BOOL)isEmptyBlock:(int)grid_x :(int)grid_y
{
    int checkIdx = [self convertGridToMap:grid_x :grid_y];
    NSString* checkPoint = [map objectAtIndex:checkIdx];
    int checkPoint_i= [checkPoint intValue];
    
    NSLog(@"【%@】【%d】",checkPoint,checkPoint_i);
    
    if (checkPoint_i == EMPTY) {
//        NSLog(@"empty【yes】");
        return YES;
    }
    else {
//        NSLog(@"empty【no】");
        return NO;
    }
    
}

//更新するタイミングを取得する
-(int)getMoveTime:(float)span{
    
    return round(lifeTime*span);
}

-(void) update:(ccTime)delta
{
    //累計時間に差分時間を足す
    lifeTime += delta;
    
    int currentTime = [self getMoveTime:span];
    
    //更新タイミングが来たら、オブジェクトの位置を進める
    if (displayTime < currentTime) {
        displayTime = currentTime;
        
//        NSLog(@"★★★GameScene:update[%i]",currentTime);
        //        NSLog(@"★★★timer_span[%d]",(int)lifeTime%timer_span);
//        NSLog(@"★★★span[%lf]",span);
        
//        Player* block = [self getChildByTag:BlockTag];

        //NOが返ってきたら、新しいブロックを生成する
        if (![self move:DOWN]) {
            activeBlock = [self createBlock];
            [self addChild:activeBlock z:0 tag:BlockTag];
        }
        
        //規定時間置きに早くなる
        if (currentTime%timer_span == 0) {
            span+=0.1;
        }
    }
}

//マップロード処理
- (NSMutableArray*)loadMap:(NSMutableArray*)fmap :(int)stageNum{
    
    NSArray* map_tmp;
    
    //file read
    NSString* TextFilePath;
    NSString* TextFileName = [NSString stringWithFormat:@"map_%i.txt",stageNum];
    TextFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:TextFileName];
    
    NSString* file_data;
    
    NSError* is_error = nil;
    
    // TextFilePath で指定されたテキストファイルを UTF8 形式で開きます。
    file_data = [NSString stringWithContentsOfFile:TextFilePath encoding:NSUTF8StringEncoding error:&is_error];
    
    // 改行を消して、カンマごとにファイルの内容を分割する
    file_data = [file_data stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    map_tmp = [file_data componentsSeparatedByString:@","];
    
    //Array->MutableArray copy
    return [map_tmp mutableCopy];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
