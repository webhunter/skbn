//
//  BlockStateObject.h
//  skbn
//
//  Created by rina.oikawa on 2013/06/13.
//
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface BlockStateObject : NSObject{
    int state;
    Player* pl_ptr;
}

@property (nonatomic)int state_;
@property (nonatomic,retain)Player* pl_ptr_;

+(id) initialize;
-(id) initObject;

@end
