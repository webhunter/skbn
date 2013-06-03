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
#define MAP_WIDTH 11
#define MAP_HEIGHT 13
#define SIZE_TILE 22
#define MAP_OFFSET_X 180
#define MAP_OFFSET_Y 30

//フィールド上のオブジェクト
#define EMPTY 0
#define BLOCK_ACTIVE 1
#define BLOCK_STAY 10
#define WALL 20

#endif // __GAME_CONFIG_H
