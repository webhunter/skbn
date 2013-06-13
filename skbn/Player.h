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
    double radian;
    int color;
}

@property (nonatomic)int direct_;
@property (nonatomic)int grid_x_;
@property (nonatomic)int grid_y_;
@property (nonatomic)double radian_;
@property (nonatomic)int color_;

+(id) initialize:(int)g_x :(int)g_y :(int)range;
-(id) initObject:(int)g_x :(int)g_y :(int)range;

@property CGPoint velocity_;

@end
