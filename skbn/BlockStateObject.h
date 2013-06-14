//
//  BlockStateObject.h
//  skbn
//
//  Created by rina.oikawa on 2013/06/13.
//
//

#import <Foundation/Foundation.h>
#import "Player.h"
//#import "FieldUnit.h"

@interface BlockStateObject : NSObject{
    int state;
    Player* pl_ptr;
}

@property (readwrite)int state_;
@property (readwrite,retain)Player* pl_ptr_;

+(id) initialize;
-(id) initObject;

@end
