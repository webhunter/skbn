//
//  Player.m
//  skbn
//
//  Created by roikawa on 13/05/27.
//
//

#import "Player.h"

@implementation Player

@synthesize grid_x_ = grid_x;
@synthesize grid_y_ = grid_y;
@synthesize direct_ = direct;
@synthesize velocity_=velocity;

+(id) initialize:(NSInteger)g_x :(NSInteger)g_y
{
    return [[[self alloc] initObject:g_x :g_y] autorelease];
}

-(id) initObject:(NSInteger)g_x :(NSInteger)g_y
{
    if ((self = [super initWithFile:@"atlas_1.png"]))
	{
        //座標初期化
        grid_x = g_x;
        grid_y = g_y;
        
        //速度初期化
        self.velocity_ = ccp(0,1);
        
        //キャッシュを読み込み
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        
        NSMutableArray* frames = [NSMutableArray arrayWithCapacity:9];
        for (int i=5; i<9; i++){
            NSString* file = [NSString stringWithFormat:@"img_%02d.png",i];
            
            //[CCSprite spriteWithSpriteFrame:frm];
            CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
            [frames addObject:frame];
        }
        
        //すべてのスプライトアニメーションフレームからアニメーションオブジェクトを生成する。
        CCAnimation *anim = [[[CCAnimation alloc] initWithSpriteFrames:frames delay:1] autorelease];
        
        //アニメーション実行
        CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
        CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
        
        [self runAction:repeat];
        
        [self scheduleUpdate];
    }

    return self;
}

-(void) dealloc
{
    // don't forget to call "super dealloc"
	[super dealloc];
}

-(void) update:(ccTime)delta
{
}

@end
