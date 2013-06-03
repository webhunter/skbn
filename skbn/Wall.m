//
//  Wall.m
//  skbn
//
//  Created by roikawa on 13/06/02.
//
//

#import "Wall.h"

@implementation Wall

+(id) initialize:(CCSpriteFrame*)frm
{
    return [[[self alloc] initObject:frm] autorelease];
}

-(id) initObject:(CCSpriteFrame*)frm
{
    [self scheduleUpdate];
    return [CCSprite spriteWithSpriteFrame:frm];
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
