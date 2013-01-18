//
//  CZGRectanglePacker.h
//  CZGTextureCreatorExamplesAndTests
//
//  Created by Christopher Garrett on 1/17/13.
//  Copyright (c) 2013 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZGRectanglePacker : NSObject

- (void) addRectangleWithSize: (CGSize) size key: (NSString *) key;
- (BOOL) pack;

- (CGRect) rectForKey: (NSString *) key;
- (CGSize) packedSize;

@end

@interface PackedRect : NSObject

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) BOOL occupied;
@property (nonatomic, strong) PackedRect *leftChild;
@property (nonatomic, strong) PackedRect *rightChild;


- (BOOL) insert: (PackedRect *) child;

@end
