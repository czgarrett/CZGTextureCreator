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
    SKTexture *_mainTexture;
    NSMutableDictionary *_textureRects;
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
        _textureRects = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSUInteger) frameCount {
    return [_drawingBlocks count];
}


- (void) addFrameWithName: (NSString *) name size: (CGSize) size drawingBlock: (CZGDrawBlock) drawingBlock {
    [self.rectanglePacker addRectangleWithSize: size key: name];
    self.drawingBlocks[name] = [drawingBlock copy];
}

- (void) addFrameWithName:(NSString *)name size:(CGSize)size htmlText:(NSString *)html {
    [self addFrameWithName: name
                      size: size
                  htmlText: html
           backgroundBlock: nil];
}

- (void) addFrameWithName: (NSString *) name size: (CGSize) size htmlText: (NSString *) html backgroundBlock:(CZGDrawBlock) backgroundBlock {
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithHTMLData:data
                                                                                    options: self.defaultTextOptions
                                                                         documentAttributes: nil];
    //    NSAttributedString *l
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString: string];
    DTCoreTextLayoutFrame *frame = [layouter layoutFrameWithRect: CGRectMake(0,0,size.width, size.height) range: NSMakeRange(0, 0)];
    //CGSize neededSize = [layouter suggestedFrameSizeToFitEntireStringConstraintedToWidth: size.width];
    //neededSize.height = MIN(neededSize.height+5.0, size.height);
    CGSize neededSize = [frame intrinsicContentFrame].size;
    neededSize.height += 5.0;
    
    UIEdgeInsets blockInsets = _frameInsets;
    
    [self addFrameWithName: name
                      size: CGSizeMake(neededSize.width + _frameInsets.left + _frameInsets.right, neededSize.height+_frameInsets.top + _frameInsets.bottom + 5.0)
              drawingBlock: ^(CGRect rect, CGContextRef ctx) {
                  if (backgroundBlock) {
                      backgroundBlock(rect, ctx);
                  }
                  DTCoreTextLayoutFrame *layoutFrame;
                  layoutFrame = [layouter layoutFrameWithRect: UIEdgeInsetsInsetRect(rect, blockInsets)
                                                        range: NSMakeRange(0, 0)];
                  [layoutFrame drawInContext: ctx
                                     options: DTCoreTextLayoutFrameDrawingOmitLinks | DTCoreTextLayoutFrameDrawingOmitAttachments];
              }];
    
}

-(SKTexture*) mainTexture {
    return _mainTexture;
}


- (void) createTexture {
    UIImage *createdImage = [self createImage];
    _mainTexture = [SKTexture textureWithImage:createdImage];
    //    NSLog(@"%f", createdImage.scale);
    for (NSString *key in [self.drawingBlocks allKeys]) {
        CGRect rect = [self.rectanglePacker rectForKey:key];
        float textureWidth = _mainTexture.size.width;
        float textureHeight = _mainTexture.size.height;
        float scale = [UIScreen mainScreen].scale;
        
        CGRect newRect = CGRectMake(scale*rect.origin.x/textureWidth,   1-scale*(rect.origin.y+rect.size.height)/textureHeight,
                                    scale*rect.size.width/textureWidth, scale*rect.size.height/textureHeight);
        _textureRects[key] = NSStringFromCGRect(newRect);
    }
}

- (SKTexture *) textureNamed: (NSString *) name {
    return [SKTexture textureWithRect:CGRectFromString(_textureRects[name]) inTexture: _mainTexture];
}

- (UIImage *) createImage {
    CGFloat scale = [UIScreen mainScreen].scale;
    [self.rectanglePacker pack];
    CGSize size = [self.rectanglePacker packedSize];
    //    size.width *= scale;
    //    size.height *= scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextScaleCTM(ctx, scale, scale);
    for (NSString *key in [self.drawingBlocks allKeys]) {
        
        CZGDrawBlock draw = self.drawingBlocks[key];
        CGContextSaveGState(ctx);
        draw([self.rectanglePacker rectForKey: key], ctx);
        CGContextRestoreGState(ctx);
    }
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end
