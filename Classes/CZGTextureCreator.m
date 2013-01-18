//
//  CZGTextureCreator.m
//  CZGTextureCreatorExamplesAndTests
//
//  Created by Christopher Garrett on 1/17/13.
//  Copyright (c) 2013 ZWorkbench. All rights reserved.
//

#import "CZGTextureCreator.h"
#import "CZGRectanglePacker.h"
#import "DTCoreText.h"

@interface CZGTextureCreator() {
    
}

@property (nonatomic, strong) CZGRectanglePacker *rectanglePacker;
@property (nonatomic, strong) NSMutableDictionary *drawingBlocks;

@end

@implementation CZGTextureCreator

- (id) init {
    self = [super init];
    if (self) {
        self.drawingBlocks = [NSMutableDictionary dictionary];
        self.rectanglePacker = [[CZGRectanglePacker alloc] init];
        self.defaultTextOptions = @{};
    }
    return self;
}

- (void) addFrameWithName: (NSString *) name size: (CGSize) size drawingBlock: (CZGDrawBlock) drawingBlock {
    [self.rectanglePacker addRectangleWithSize: size key: name];
    self.drawingBlocks[name] = [drawingBlock copy];
}

- (void) addFrameWithName: (NSString *) name size: (CGSize) size htmlText: (NSString *) html {
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data
                                                                      options: self.defaultTextOptions
                                                           documentAttributes: nil];
    
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString: string];
    CGSize neededSize = [layouter suggestedFrameSizeToFitEntireStringConstraintedToWidth: size.width];
    neededSize.height = MIN(neededSize.height+5.0, size.height);
    
    [self addFrameWithName: name
                      size: CGSizeMake(neededSize.width, neededSize.height+5.0)
              drawingBlock: ^(CGRect rect, CGContextRef ctx) {
                  DTCoreTextLayoutFrame *layoutFrame;
                  layoutFrame = [layouter layoutFrameWithRect:rect
                                                        range: NSMakeRange(0, 0)];
                  [layoutFrame drawInContext: ctx
                                  drawImages: NO
                                   drawLinks: NO];
              }];
    
}


- (CCTexture2D *) createTexture {
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    CCTexture2D *texture = [[CCTexture2D alloc] initWithCGImage: [self createImage].CGImage resolutionType: kCCResolutioniPhone];
    for (NSString *key in [self.drawingBlocks allKeys]) {
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture: texture rect: [self.rectanglePacker rectForKey: key]];
        [frameCache addSpriteFrame: frame name: key];
    }
    return texture;
}

- (void) clearFramesFromCache {
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    for (NSString *key in [self.drawingBlocks allKeys]) {
        [frameCache removeSpriteFrameByName: key];
    }
}

- (UIImage *) createImage {
    [self.rectanglePacker pack];
    UIGraphicsBeginImageContext([self.rectanglePacker packedSize]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (NSString *key in [self.drawingBlocks allKeys]) {
        CZGDrawBlock draw = self.drawingBlocks[key];
        draw([self.rectanglePacker rectForKey: key], ctx);
    }
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end
