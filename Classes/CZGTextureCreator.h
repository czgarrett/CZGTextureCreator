//
//  CZGTextureCreator.h
//  CZGTextureCreatorExamplesAndTests
//
//  Created by Christopher Garrett on 1/17/13.
//  Copyright (c) 2013 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef void(^CZGDrawBlock)(CGRect rect, CGContextRef ctx);

@interface CZGTextureCreator : NSObject

// A dictionary of DTCoreText options.
// Example:
/*
 textureCreator.defaultTextOptions =  @{  DTDefaultFontFamily : @"Futura",
                                          DTDefaultTextColor  : @"white"};
 */
@property (nonatomic, strong) NSDictionary *defaultTextOptions;

- (void) addFrameWithName: (NSString *) name size: (CGSize) size drawingBlock: (CZGDrawBlock) drawingBlock;
- (void) addFrameWithName: (NSString *) name size: (CGSize) size htmlText: (NSString *) html;

- (CCTexture2D *) createTexture;

// Removes all of the sprite frames from the cache.  This will allow the texture to be released.
- (void) clearFramesFromCache;


@end
