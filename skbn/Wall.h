//
//  Wall.h
//  skbn
//
//  Created by roikawa on 13/06/02.
//
//

//#import "FieldUnit.h"
#import "CCSprite.h"
#import "cocos2d.h"

@interface Wall : CCSprite{
}

+(id) initialize:(CCSpriteFrame*)frm;
-(id) initObject:(CCSpriteFrame*)frm;

@end
