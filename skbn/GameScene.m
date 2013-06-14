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
//#import "BlockStateObject.h"
//#import "FieldUnit.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - GameScene

// GameScene implementation
@implementation GameScene

@synthesize block_range_ = block_range;
@synthesize activeBlock_ = activeBlock;
@synthesize activeBlock2_ = activeBlock2;
@synthesize wallList_ = wallList;
@synthesize map_ = map;
@synthesize map_offset_x_ = map_offset_x;
@synthesize map_offset_y_ = map_offset_y;
//@synthesize tile_ = tile[MAP_HEIGHT][];

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
        block_range = 5;
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        //MAPオフセット
        map_offset_x = screenSize.width/3;
        map_offset_y = screenSize.height/9;
        
        //タッチイベント
        self.isTouchEnabled = YES;
        
        //atlas読み込み
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"atlas_1.plist"];
        [atlasImg initWithFile:@"atlas_1.png"];
        
        //操作UI描画
        //コントロールパネル
        //左
        btn_l = [CCMenuItemImage
                          itemFromNormalImage:@"gls_blue_up.png" selectedImage:@"gls_blue_down.png"
                                  target:self selector:@selector(controllerTapped:)];
        btn_l.position = ccp(screenSize.width/9, screenSize.height/2);
        
        float btnSizeWidth = btn_l.contentSize.width;
        float btnSizeHeight = btn_l.contentSize.height;
        
        //下
        btn_d = [CCMenuItemImage
                 itemFromNormalImage:@"gls_blue_up.png" selectedImage:@"gls_blue_down.png"
                 target:self selector:@selector(controllerTapped:)];
        btn_d.position = ccp(screenSize.width/9+btnSizeWidth/2, screenSize.height/2-btnSizeHeight);
        
        //右
        btn_r = [CCMenuItemImage
                                  itemFromNormalImage:@"gls_blue_up.png" selectedImage:@"gls_blue_down.png"
                                  target:self selector:@selector(controllerTapped:)];
        btn_r.position = ccp(screenSize.width/9+btnSizeWidth, screenSize.height/2);
        
        //上
        btn_u = [CCMenuItemImage
                 itemFromNormalImage:@"gls_blue_up.png" selectedImage:@"gls_blue_down.png"
                 target:self selector:@selector(controllerTapped:)];
        btn_u.position = ccp(screenSize.width/9+btnSizeWidth/2, screenSize.height/2+btnSizeHeight);
        
        //Aボタン
        btn_a = [CCMenuItemImage
                 itemFromNormalImage:@"gls_red_up.png" selectedImage:@"gls_red_down.png"
                 target:self selector:@selector(controllerTapped_rotation:)];
        btn_a.position = ccp(screenSize.width/9*7+btnSizeWidth/4, screenSize.height/2);
        
        //Bボタン
        btn_b = [CCMenuItemImage
                 itemFromNormalImage:@"gls_green_up.png" selectedImage:@"gls_green_down.png"
                 target:self selector:@selector(controllerTapped_rotation:)];
        btn_b.position = ccp(screenSize.width/9*7+btnSizeWidth/4*5, screenSize.height/2);
        
        //メニューに追加
        CCMenu *controlMenu = [CCMenu menuWithItems:btn_l,btn_d,btn_r,btn_u,btn_a,btn_b, nil];
        
        controlMenu.position = CGPointZero;
        [self addChild:controlMenu z:3 tag:ControlUITagGame];
        
        //マップ読み込み
        int stageNum = 1;
        map = [self loadMap:map :stageNum];
        
        //マップ描画
        wallList = [CCSpriteBatchNode batchNodeWithFile:@"atlas_1.png"];
        [self addChild:wallList z:0 tag:WallTag];
        
        int point;
        for (int i=0; i<MAP_HEIGHT; i++){
            for (int j=0; j<MAP_WIDTH; j++){
                //マップから該当する座標のオブジェクト種類を取得する
//                BlockStateObject* bl = [map objectAtIndex:[self convertGridToMap:j :i]];
                point = [map objectAtIndex:[self convertGridToMap:j :i]];
                
                //数値に変換
//                int point_coord = [point intValue];
                
                if (point == EMPTY) {   //何もない空間はエスケープ
//                if (point_coord == EMPTY) {   //何もない空間はエスケープ
                    continue;
                }
//                else if(point_coord>0 && point_coord<20){   //未来使用
//                    NSString* file = [NSString stringWithFormat:@"img_%02d.png",point_coord];
//                }
                else if (point == WALL){  //壁
//                    else if (point_coord == WALL){  //壁
                    CCSpriteFrame* frm = [frameCache spriteFrameByName:@"img_20.png"];
                    
                    Wall* wall = [Wall initialize:frm];
                    wall.position = [self convertGridToCcp:j :i];
                    
                    [wallList addChild:wall z:0 tag:WallTag];
                }
            }
        }
                
        //ブロック生成
        activeBlock = [self createBlock:block_range :1];
//        [self addChild:activeBlock z:0 tag:BlockTag];
        
        activeBlock2 = [self createBlock:block_range :2];
//        [self addChild:activeBlock2 z:0 tag:BlockTag];

//        [self scheduleUpdate];
	}
	return self;
}

//ブロック生成処理
-(BlockStateObject*)createBlock:(int)range :(int)rank
{
    int grid_x,grid_y=0;
    
    if (rank == 1) {
        grid_x = BLOCK1_DEFAULT_X;
        grid_y = BLOCK1_DEFAULT_Y;
    }
    else{
        grid_x = BLOCK2_DEFAULT_X;
        grid_y = BLOCK2_DEFAULT_Y;
    }
    
    Player* block = [Player initialize:grid_x :grid_y :range];
    
    //実座標更新
    block.position = [self convertGridToCcp:grid_x :grid_y];
    [self addChild:block z:0 tag:BlockTag];
    
    //グリッド座標更新
    int placeIdx = [self convertGridToMap:block.grid_x_ :block.grid_y_];
    return [self updateMap:placeIdx :block];
    
//    NSString* setValue = [NSString stringWithFormat:@"%02d",BLOCK_ACTIVE];
//    int replaceIdx = [self convertGridToMap:block.grid_x_ :block.grid_y_];
//    BlockStateObject* bl = [map objectAtIndex:replaceIdx];
//    bl.pl_ptr_ = block;
//    bl.state_ = BLOCK_ACTIVE;
//    [map replaceObjectAtIndex:replaceIdx withObject:bl];
    
//    return block;
}

//Gridマップ更新
- (BlockStateObject*)updateMap:(int)old_Idx :(Player*)block
{
    //現在の座標をクリア
    BlockStateObject* blso_old = [BlockStateObject initialize];
//    BlockStateObject* blso_old = [map objectAtIndex:old_Idx];
    blso_old.pl_ptr_ = NULL;
    blso_old.state_ = EMPTY;
    [map removeObjectAtIndex:old_Idx];
    [map insertObject:blso_old atIndex:old_Idx];
    
    //更新
    int replaceIdx = [self convertGridToMap:block.grid_x_ :block.grid_y_];
    BlockStateObject* blso = [map objectAtIndex:replaceIdx];
    blso.pl_ptr_ = block;
    blso.state_ = BLOCK_ACTIVE;
    [map removeObjectAtIndex:replaceIdx];
    [map insertObject:blso atIndex:replaceIdx];
//    [map replaceObjectAtIndex:replaceIdx withObject:blso];
    
    NSLog(@"count:【%d】",map.count);
    return blso;
}

//座標変換(grid->map)
-(int)convertGridToMap:(int)grid_x :(int)grid_y
{
    return MAP_WIDTH * grid_y + grid_x;   //grid_y回分WIDTHが回った
}

//座標変換(grid->ccp)
-(CGPoint)convertGridToCcp:(int)grid_x :(int)grid_y
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint pos = ccp(self.map_offset_x_ + grid_x * SIZE_TILE, screenSize.height - (self.map_offset_y_ + grid_y * SIZE_TILE));
    return pos;
}

//座標変換(ccp->grid)
-(CGPoint)convertCcpToGrid:(int)pos_x :(int)pos_y
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    return CGPointMake((pos_x - self.map_offset_x_)/SIZE_TILE,(screenSize.height - pos_y - self.map_offset_y_)/SIZE_TILE);
    
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
    //移動方向に対して前方にあるブロックユニットを取得する
    NSMutableArray* forwardMap = [self fowardCheck:dir];
    
    //前方にある方から移動する
    for (int i=0; i<forwardMap.count; i++) {
        Player* pl = [forwardMap objectAtIndex:i];
        [self move:pl :dir];
    }
}

//コントローラー・ブロック回転
- (void)controllerTapped_rotation:(id)sender{
    CCMenuItemImage* btn = sender;
    int dir = NOP;
    
    if (btn.hash == btn_a.hash) {   //左回転
        dir = ROT_LEFT;
    }
    else if (btn.hash == btn_b.hash) {   //右回転
        dir = ROT_RIGHT;
    }
    
    //セカンダリブロックユニットを回転させる
//    if ([activeBlock2.pl_ptr_ isKindOfClass:[Player class]]) {
//        [self rotation:activeBlock2.pl_ptr_ :dir :activeBlock.pl_ptr_.grid_x_ :activeBlock.pl_ptr_.grid_y_];
//    }
    [self rotation:activeBlock2.pl_ptr_ :dir :activeBlock.pl_ptr_.grid_x_ :activeBlock.pl_ptr_.grid_y_];
}

//進行方向に対して前方に存在するブロックパーツを判別する
-(NSMutableArray*)fowardCheck:(int)dir{
    
    NSMutableArray* moveSequenceMap = [NSMutableArray arrayWithCapacity:2];
    
    //移動先を調査
    if (dir == LEFT){   //左
        if (activeBlock.pl_ptr_.grid_x_ > activeBlock2.pl_ptr_.grid_x_) {   //プライマリが右（＝x軸座標が大きい）場合、セカンダリが前方
            [moveSequenceMap addObject:activeBlock2];
            [moveSequenceMap addObject:activeBlock];
        }else
        {
            [moveSequenceMap addObject:activeBlock];
            [moveSequenceMap addObject:activeBlock2];
        }
    }
    else if (dir == RIGHT){ //右
        if (activeBlock.pl_ptr_.grid_x_ < activeBlock2.pl_ptr_.grid_x_) {   //プライマリが左（＝x軸座標が小さい）場合、セカンダリが前方
            [moveSequenceMap addObject:activeBlock2];
            [moveSequenceMap addObject:activeBlock];
        }else
        {
            [moveSequenceMap addObject:activeBlock];
            [moveSequenceMap addObject:activeBlock2];
        }
    }
    else if (dir == DOWN) {  //下
        if (activeBlock.pl_ptr_.grid_y_ < activeBlock2.pl_ptr_.grid_y_) {   //プライマリが上（＝y軸座標が小さい）場合、セカンダリが前方
            [moveSequenceMap addObject:activeBlock2];
            [moveSequenceMap addObject:activeBlock];
        }else
        {
            [moveSequenceMap addObject:activeBlock];
            [moveSequenceMap addObject:activeBlock2];
        }
    }
    return moveSequenceMap;
}

-(BOOL)rotation:(Player*)block :(int)dir :(int)center_x :(int)center_y{
    
    //現在のグリッド座標の状態取得
    int nowIdx = [self convertGridToMap:block.grid_x_ :block.grid_y_];
    int nowState= [self getGridState:block.grid_x_ :block.grid_y_];
    
    //STAY状態の場合、終了
    if (nowState == BLOCK_STAY) {
        return NO;
    }
    
    //座標更新のために現在のグリッド座標の状態をEMPTYに戻す
    [map replaceObjectAtIndex:nowIdx withObject:[NSString stringWithFormat:@"%02d",EMPTY]];
    
    //移動継続フラグ(座標的に移動可能かどうかを判別するフラグ)
    BOOL wall_check = YES;
    
    double next_radian = block.radian_;
    
    //ブロックの状態
    NSString* setValue = [NSString stringWithFormat:@"%02d",BLOCK_ACTIVE];
    
    if (dir == ROT_LEFT){   //左回転
        next_radian = -M_PI_2;
    }
    else if (dir == ROT_RIGHT){ //右回転
        next_radian = M_PI_2;
    }
    
    //移動先を調査して、移動可能な場合、回転する
    NSMutableArray* coor = [self gridRotate:block.grid_x_ :block.grid_y_ :next_radian :center_x :center_y];
    
    int next_grid_x = [[coor objectAtIndex:0] intValue];
    int next_grid_y = [[coor objectAtIndex:1] intValue];
    
    NSLog(@"@@@【%d】【%d】",next_grid_x, next_grid_y);
    
    if ([self isEmptyBlock:next_grid_x :next_grid_y]) {
        block.grid_x_ = next_grid_x;
        block.grid_y_ = next_grid_y;
    }
    
    //ブロックピースの移動
    block.position = [self convertGridToCcp:block.grid_x_ :block.grid_y_];
    
    //グリッド座標を更新する
    [self updateMap:nowIdx :block];
    
//    int replaceIdx = [self convertGridToMap:block.grid_x_ :block.grid_y_];
//    [map replaceObjectAtIndex:replaceIdx withObject:setValue];
    
    return wall_check;
}

//グリッド座標回転
-(NSMutableArray*)gridRotate:(int)grid_x :(int)grid_y :(double)radian :(int)center_x :(int)center_y
{
    NSMutableArray* coordinate = [NSMutableArray arrayWithCapacity:2];
    
    //x座標回転
    double elem_1 = cos(radian);
    double elem_2 = sin(radian);
    
    //doubleのまま計算すると、-0.0で計算され、結果不正となる
    NSNumber* elem_n_1 = [[NSNumber alloc] initWithDouble:elem_1];
    NSNumber* elem_n_2 = [[NSNumber alloc] initWithDouble:elem_2];
    
//    NSLog(@"@@@grid_x:【%d】", grid_x);
//    NSLog(@"@@@grid_y:【%d】", grid_y);
//    
//    NSLog(@"@@@center_x:【%d】", center_x);
//    NSLog(@"@@@center_y:【%d】", center_y);
    
    int rotate_grid_x = [elem_n_1 intValue] * (grid_x-center_x) - [elem_n_2 intValue] * (grid_y-center_y) + center_x;
    int rotate_grid_y = [elem_n_2 intValue] * (grid_x-center_x) + [elem_n_1 intValue] * (grid_y-center_y) + center_y;
    
    NSLog(@"@@@rotate_grid_x:【%d】", rotate_grid_x);
    NSLog(@"@@@rotate_grid_y:【%d】", rotate_grid_y);
    
    NSNumber *x = [[NSNumber alloc] initWithInt:rotate_grid_x];
    NSNumber *y = [[NSNumber alloc] initWithInt:rotate_grid_y];
    
    //x,yの順番で格納
    [coordinate addObject:x];
    [coordinate addObject:y];
    
    return coordinate;
}

//@@@移動メソッド
-(BOOL)move:(Player*)block :(int)dir{
        
    //現在のグリッド座標の状態取得
    int nowIdx = [self convertGridToMap:block.grid_x_ :block.grid_y_];
    int nowState= [self getGridState:block.grid_x_ :block.grid_y_];
    
    //STAY状態の場合、終了
    if (nowState == BLOCK_STAY) {
        return NO;
    }

    //座標更新のために現在のグリッド座標の状態をEMPTYに戻す
    [map replaceObjectAtIndex:nowIdx withObject:[NSString stringWithFormat:@"%02d",EMPTY]];
    
    //移動継続フラグ(座標的に移動可能かどうかを判別するフラグ)
    BOOL wall_check = YES;
    
    int next_grid_x = block.grid_x_;
    int next_grid_y = block.grid_y_;
    
    //ブロックの状態
    NSString* setValue = [NSString stringWithFormat:@"%02d",BLOCK_ACTIVE];
    
    //移動先を調査して、移動可能な場合、１グリッド分移動する
    if (dir == LEFT){   //左
        next_grid_x -= 1;
        
        if ([self isEmptyBlock:next_grid_x :next_grid_y]) {
            block.grid_x_ = next_grid_x;
        }
    }
    else if (dir == RIGHT){ //右
        next_grid_x += 1;
        
        if ([self isEmptyBlock:next_grid_x :next_grid_y]) {
            block.grid_x_ = next_grid_x;
        }
    }
    else if (dir == DOWN) {  //下
        next_grid_y += 1;
        
        if ([self isEmptyBlock:next_grid_x :next_grid_y]) {
            block.grid_y_ = next_grid_y;
        }
    }
    
    //ブロックピースの移動
    block.position = [self convertGridToCcp:block.grid_x_ :block.grid_y_];
    
    //移動後に一歩先を見て、移動できない場合、ブロックの状態をSTAYにする
    next_grid_x = block.grid_x_;
    next_grid_y = block.grid_y_;
    next_grid_y += 1;
    if (![self isEmptyBlock:next_grid_x :next_grid_y] && ![self isActiveBlock:next_grid_x :next_grid_y]){ //空白でない、かつ、アクティブブロックでない
        setValue = [NSString stringWithFormat:@"%02d",BLOCK_STAY];
        wall_check = NO;
    }
    
    //グリッド座標を更新する
    [self updateMap:nowIdx :block];
//    int replaceIdx = [self convertGridToMap:block.grid_x_ :block.grid_y_];
//    [map replaceObjectAtIndex:replaceIdx withObject:setValue];
    
    return wall_check;
}

//指定したグリッド座標の状態を取得する
-(int)getGridState:(int)grid_x :(int)grid_y
{
    int replaceIdx = [self convertGridToMap:grid_x :grid_y];
    BlockStateObject* blso = [map objectAtIndex:replaceIdx];
    return blso.state_;
    
//    int checkIdx = [self convertGridToMap:grid_x :grid_y];
//    NSString* checkPoint = [map objectAtIndex:checkIdx];
//    return [checkPoint intValue];
}

//指定した座標がEMPTYかどうかを調べる
-(BOOL)isEmptyBlock:(int)grid_x :(int)grid_y
{
    int checkPoint_i= [self getGridState:grid_x :grid_y];
    
    if (checkPoint_i == EMPTY) {
        return YES;
    }
    else {
        return NO;
    }
}

//指定した座標がBLOCK_ACTIVEかどうかを調べる
-(BOOL)isActiveBlock:(int)grid_x :(int)grid_y
{
    int checkPoint_i= [self getGridState:grid_x :grid_y];
    
    if (checkPoint_i == BLOCK_ACTIVE) {
        return YES;
    }
    else {
        return NO;
    }
}

//更新するタイミングを取得する
-(int)getMoveTime:(float)span{
    
    return round(lifeTime*span);
}

//ブロックの固定処理（片方のブロックユニットが固定された場合に呼び出し）
-(BOOL)fixBlock
{
    while (YES) {
        if (![self move:activeBlock.pl_ptr_ :DOWN]) {
            break;
        }
    }
    while (YES) {
        if (![self move:activeBlock2.pl_ptr_ :DOWN]) {
            break;
        }
    }
    return YES;
}

//ブロックの消去

//連結領域のカウント
-(void)Count:(Player*)pl :(NSInteger)n
{
    //色取得
//    int check_color = pl.color_;
    
    //上
    
    //下
    
    //右
    
    //左
}

-(void) update:(ccTime)delta
{
    //累計時間に差分時間を足す
    lifeTime += delta;
    
    int currentTime = [self getMoveTime:span];
    
    //更新タイミングが来たら、オブジェクトの位置を進める
    if (displayTime < currentTime) {
        displayTime = currentTime;
        
        //移動
        //移動方向に対して前方にあるブロックユニットを取得する
        NSMutableArray* forwardMap = [self fowardCheck:DOWN];
        
        //前方にある方から移動する
        bool canBlock = YES;
        for (int i=0; i<forwardMap.count; i++) {
            Player* pl = [forwardMap objectAtIndex:i];
            
            if (![self move:pl :DOWN]) {
                canBlock = NO;
                break;
            }
        }
        
        //いずれかのブロックピースがSTAY状態になったら、もう片方のブロックピースを底面まで移動させる
        if (canBlock == NO) {
            [self fixBlock];
            
            //ブロックの移動が終わったら、連結領域の判定・ブロックの消去
            
            //新しいブロック生成
            activeBlock = [self createBlock:self.block_range_ :1];
//            [self addChild:activeBlock z:0 tag:BlockTag];
            
            activeBlock2 = [self createBlock:self.block_range_ :2];
//            [self addChild:activeBlock2 z:0 tag:BlockTag];
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
    
    //NSMutableArrayにコピーする
    NSMutableArray* stateMap = [[NSMutableArray alloc] initWithCapacity:map_tmp.count];
    for (int i=0; i<map_tmp.count; i++) {
        [stateMap addObject:[[map_tmp objectAtIndex:i] intValue]];
    }
//    NSMutableArray* stateMap = [[NSMutableArray alloc] initWithCapacity:map_tmp.count];
//    for (int i=0; i<map_tmp.count; i++) {
//        BlockStateObject *bl = [BlockStateObject initialize];
//        bl.state_ = [[map_tmp objectAtIndex:i] intValue];  //string->intに変換
//        bl.pl_ptr_ = NULL;
//        [stateMap addObject:bl];
//    }
    
    NSLog(@"item count:%d",map_tmp.count);
    return stateMap;
    
    //Array->MutableArray copy
//    return [map_tmp mutableCopy];
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
