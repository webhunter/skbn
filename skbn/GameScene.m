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
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedJoystickExample.h"
//#import "SneakyJoystickSkinnedDPadExample.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredCircleSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - GameScene

// GameScene implementation
@implementation GameScene

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
        timer_span = 10;
        
        //タッチイベント
        self.isTouchEnabled = YES;
        
        //atlas読み込み
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"atlas_1.plist"];
        [atlasImg initWithFile:@"atlas_1.png"];
        
        //マップ読み込み
        NSInteger stageNum = 1;
        NSArray* map = [self loadMap:stageNum];
        
        //マップ描画
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        NSString* point;
        for (int i=0; i<MAP_HEIGHT; i++){
            for (int j=0; j<MAP_WIDTH; j++){
                point = [map objectAtIndex:i*MAP_WIDTH+j];  //i回分WIDTHが回った
                
//                NSLog(@"loadMap<%@>",point);
                
                //数値に変換
                int point_coord = [point intValue];
                
                if (point_coord==0) {   //何もない空間はエスケープ
                    continue;
                }
                else{
                    NSString* file = [NSString stringWithFormat:@"img_%02d.png",point_coord];
                    CCSpriteFrame* tmp = [frameCache spriteFrameByName:file];
                    CCSprite* img = [CCSprite spriteWithSpriteFrame:tmp];
                    img.position = ccp(MAP_OFFSET_X + j * SIZE_TILE, screenSize.height - (MAP_OFFSET_Y + i * SIZE_TILE));
                    [self addChild:img];
                }
            }
        }
        
        //ブロック生成
        Player* player = [Player player];
        blockPointer = player;
        player.position = ccp(MAP_OFFSET_X + SIZE_TILE, screenSize.height - MAP_OFFSET_Y);
        [self addChild:player];
        
        [self scheduleUpdate];
		
//		// create and initialize a Label
//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
//
//		// ask director for the window size
//		CGSize size = [[CCDirector sharedDirector] winSize];
//	
//		// position the label on the center of the screen
//		label.position =  ccp( size.width /2 , size.height/2 );
//		
//		// add the label as a child to this Layer
//		[self addChild: label];
//		
//		
//		
//		//
//		// Leaderboards and Achievements
//		//
//		
//		// Default font size will be 28 points.
//		[CCMenuItemFont setFontSize:28];
//		
//		// Achievement Menu Item using blocks
//		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
//			
//			
//			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
//			achivementViewController.achievementDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:achivementViewController animated:YES];
//			
//			[achivementViewController release];
//		}
//									   ];
//
//		// Leaderboard Menu Item using blocks
//		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
//			
//			
//			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
//			leaderboardViewController.leaderboardDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
//			
//			[leaderboardViewController release];
//		}
//									   ];
//		
//		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
//		
//		[menu alignItemsHorizontallyWithPadding:20];
//		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
//		
//		// Add the menu to the layer
//		[self addChild:menu];

	}
	return self;
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
        
        NSLog(@"★★★GameScene:update[%i]",currentTime);
        //        NSLog(@"★★★timer_span[%d]",(int)lifeTime%timer_span);
        NSLog(@"★★★span[%lf]",span);
        
        blockPointer.position = ccp(blockPointer.position.x, blockPointer.position.y - 100  * delta);
        
        //規定時間置きに早くなる
        if (currentTime%timer_span == 0) {
            span+=0.1;
        }
    }
}

//マップロード処理
- (NSArray*)loadMap:(NSInteger)stageNum{
    
    NSArray* map;
    
    //file read
    NSString* TextFilePath;
    NSString* TextFileName = [NSString stringWithFormat:@"map_%i.txt",stageNum];
    TextFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:TextFileName];
    
//    NSInteger line_index;
    NSString* file_data;
    
    NSError* is_error = nil;
    
    // TextFilePath で指定されたテキストファイルを UTF8 形式で開きます。
    file_data = [NSString stringWithContentsOfFile:TextFilePath encoding:NSUTF8StringEncoding error:&is_error];
    
    // 改行を消して、カンマごとにファイルの内容を分割する
    file_data = [file_data stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    map = [file_data componentsSeparatedByString:@","];
    
//    // 分割文字分だけ、繰り返し処理を行います。
//    for (int i = 0; i < map.count; i++)
//    {
//        NSLog(@"data_lines<%@>",[map objectAtIndex:i]);
//    }
    
    return map;
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