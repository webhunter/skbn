//
//  BlockStateObject.m
//  skbn
//
//  Created by rina.oikawa on 2013/06/13.
//
//

#import "BlockStateObject.h"
#import "GameConfig.h"

@implementation BlockStateObject

@synthesize state_ = state;
@synthesize pl_ptr_ = pl_ptr;

+(id) initialize
{
    return [[[self alloc] initObject] autorelease];
}

-(id) initObject
{
    state = EMPTY;
    pl_ptr = NULL;
    
    return self;
}

-(void) dealloc
{
    // don't forget to call "super dealloc"
    self.pl_ptr_ = NULL;
	[super dealloc];
}

@end
