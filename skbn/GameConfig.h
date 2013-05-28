//
//  GameConfig.h
//  skbn
//
//  Created by roikawa on 13/05/28.
//
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationUIViewController
//#define GAME_AUTOROTATION kGameAutorotationNone

//★★★追加
#define STAGE_WIDTH 12
#define STAGE_HEIGHT 12


#endif // __GAME_CONFIG_H
