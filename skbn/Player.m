//
//  Player.m
//  skbn
//
//  Created by roikawa on 13/05/27.
//
//

#import "Player.h"

@implementation Player

@synthesize velocity_=velocity;

+(id)player{
    return [[[self alloc] initPlayer] autorelease];
}

-(id) initPlayer
{
    //スプライトのフレーム名を使って画像読み込み
    if ((self = [super initWithFile:@"atlas_1.png"]))
	{
        //速度初期化
        self.velocity_ = ccp(0,100);
        
        //キャッシュを読み込み
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        
        NSMutableArray* frames = [NSMutableArray arrayWithCapacity:9];
        for (int i=5; i<9; i++){
            NSString* file = [NSString stringWithFormat:@"img_%02d.png",i];
            
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
