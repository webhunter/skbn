//
//  Player.m
//  skbn
//
//  Created by roikawa on 13/05/27.
//
//

#import "Player.h"

@implementation Player

+(id)player{
    return [[[self alloc] initPlayer] autorelease];
}

-(id) initPlayer
{
	//atlas読み込み
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"atlas1.plist"];
    
    //スプライトのフレーム名を使って画像読み込み
    if ((self = [super initWithFile:@"atlas1.png"]))
	{
        //アニメーションフレームを読み込み
        NSMutableArray* frames = [NSMutableArray arrayWithCapacity:9];
        for (int i=1; i<9; i++){
            NSString* file = [NSString stringWithFormat:@" chara_0%i.png",i];
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
