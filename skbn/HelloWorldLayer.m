//
//  HelloWorldLayer.m
//  skbn
//
//  Created by roikawa on 13/05/26.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Player.h"
#import "GameConfig.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        //ステージ生成
        NSMutableArray* map = [NSMutableArray arrayWithCapacity:STAGE_WIDTH*STAGE_HEIGHT];
        
        //file read
        NSString* TextFileName;
        NSString* TextFilePath;
        
        TextFileName = @"example.txt";
        TextFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:TextFileName];
        
        NSInteger line_index;
        
        NSString* file_data;
        NSArray* data_lines;
        NSString* data_line;
        
        NSError* is_error = nil;
        
        // TextFilePath で指定されたテキストファイルを UTF8 形式で開きます。
        file_data = [NSString stringWithContentsOfFile:TextFilePath encoding:NSUTF8StringEncoding error:&is_error];
        
        if (is_error == nil)
        {
            // 改行ごとにファイルの内容を分割しています。
            data_lines = [file_data componentsSeparatedByString:@"\n"];
            
            // 存在する行の数だけ、繰り返し処理を行います。
            for (line_index = 0; line_index < data_lines.count; line_index++)
            {
                data_line = [data_lines objectAtIndex:line_index];
                
                NSLog(@"line<%@>",data_line);
                
            }
        }
        else
        {
            // ファイルが開けなかった場合のエラー処理です。
            NSLog([is_error localizedDescription]);
        }
        
//        NSArray* map = [[NSArray alloc] initWithObjects:
//            20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
//            20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
//            20, 20, 16, 16, 16, 16, 16, 16, 16, 20, 20, 20,
//            20, 20, 16, 19, 20, 19, 20, 19, 16, 20, 20, 20,
//            20, 20, 16, 20, 17, 17, 17, 20, 16, 20, 20, 20,
//            20, 20, 16, 19, 17, 04, 17, 19, 16, 20, 20, 20,
//            20, 20, 16, 20, 17, 17, 17, 20, 16, 20, 20, 20,
//            20, 20, 16, 19, 20, 19, 20, 19, 16, 20, 20, 20,
//            20, 20, 16, 16, 16, 16, 16, 16, 16, 20, 20, 20,
//            20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
//            20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
//            20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20];
//        
//        for (int i = 0; i < STAGE_WIDTH*STAGE_HEIGHT; ++i){
//        }
        
        //プレイヤー生成
        Player* player = [Player player];
        player.position = CGPointMake(100, 100);
        [self addChild:player];
		
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
