//
//  Player.h
//  skbn
//
//  Created by roikawa on 13/05/27.
//
//

#import "CCSprite.h"
#import "cocos2d.h"

#import "GameScene.h"

@interface Player : CCSprite {
}

+(id)player;

@property CGPoint velocity_;

@end
