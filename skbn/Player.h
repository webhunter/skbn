//
//  Player.h
//  skbn
//
//  Created by roikawa on 13/05/27.
//
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface Player : CCSprite {
    NSInteger direct;
    NSInteger grid_x;
    NSInteger grid_y;
}

@property (nonatomic)NSInteger direct_;
@property (nonatomic)NSInteger grid_x_;
@property (nonatomic)NSInteger grid_y_;


+(id) initialize:(NSInteger)g_x :(NSInteger)g_y;
-(id) initObject:(NSInteger)g_x :(NSInteger)g_y;

@property CGPoint velocity_;

@end
