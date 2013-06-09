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
    int direct;
    int grid_x;
    int grid_y;
}

@property (nonatomic)int direct_;
@property (nonatomic)int grid_x_;
@property (nonatomic)int grid_y_;


+(id) initialize:(int)g_x :(int)g_y :(int)range;
-(id) initObject:(int)g_x :(int)g_y :(int)range;

@property CGPoint velocity_;

@end
