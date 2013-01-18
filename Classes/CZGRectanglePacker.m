//
//  CZGRectanglePacker.m
//  CZGTextureCreatorExamplesAndTests
//
//  Created by Christopher Garrett on 1/17/13.
//  Copyright (c) 2013 ZWorkbench. All rights reserved.
//

#import "CZGRectanglePacker.h"
#import "cocos2d.h"

@interface CZGRectanglePacker() {
    
}

@property (nonatomic, strong) NSMutableDictionary *packedRects;
@property (nonatomic, assign) CGSize packedSize;
@property (nonatomic, strong) PackedRect *root;
@property (nonatomic, assign) int maxDimension;
@property (nonatomic, assign) int startingWidth;
@property (nonatomic, assign) int startingHeight;
@property (nonatomic, assign) float totalArea;

@end

@implementation CZGRectanglePacker

- (id) init {
    self = [super init];
    if (self) {
        self.startingHeight = 1;
        self.startingWidth = 1;
        self.totalArea = 0.0;
        self.packedRects = [NSMutableDictionary dictionary];
        glGetIntegerv(GL_MAX_TEXTURE_SIZE, &_maxDimension);
    }
    return self;
}

- (void) addRectangleWithSize: (CGSize) size key: (NSString *) key {
    PackedRect *packed = [[PackedRect alloc] init];
    packed.rect = CGRectMake(0,0,size.width, size.height);
    packed.occupied = YES;
    self.totalArea += size.width*size.height;
    while (size.width >= self.startingWidth && self.startingWidth <= self.maxDimension) self.startingWidth *=2;
    while (size.height >= self.startingHeight && self.startingHeight <= self.maxDimension) self.startingHeight *=2;
    while (self.startingHeight*self.startingWidth < self.totalArea) {
        self.startingHeight = MIN(self.maxDimension, self.startingHeight*2);
        self.startingWidth = MIN(self.maxDimension, self.startingWidth*2);
    }
    self.packedRects[key] = packed;
}

- (BOOL) pack {
    NSArray *sortedRects = [[self.packedRects allValues] sortedArrayUsingSelector: @selector(compareTo:)];
    int packedWidth;
    int packedHeight;
    BOOL resized = YES;
    while (resized) {
        self.root = [[PackedRect alloc] init];
        self.root.rect = CGRectMake(0,0, self.startingWidth, self.startingHeight);
        resized = NO;
        packedWidth = 0;
        packedHeight = 0;
        for (PackedRect *child in sortedRects) {
            if (!resized) {
                if ([self.root insert: child]) {
                    packedWidth = MAX(child.rect.origin.x + child.rect.size.width, packedWidth);
                    packedHeight = MAX(child.rect.origin.y + child.rect.size.height, packedHeight);
                } else {
                    if (self.startingWidth == self.maxDimension && self.startingHeight == self.maxDimension) {
                        // no room, even at max dimension
                        return NO;
                    }
                    if (self.startingWidth < self.maxDimension) self.startingWidth *=2;
                    if (self.startingHeight < self.maxDimension) self.startingHeight *=2;
                    resized = YES;
                }
            }
        }
    }
    // convert packed width and height to next power of 2 up
    int pow2Width = 1;
    while (pow2Width < packedWidth) pow2Width *=2;
    int pow2Height = 1;
    while (pow2Height < packedHeight) pow2Height *=2;
    self.root.rect = CGRectMake(0,0,pow2Width, pow2Height);
    return YES;
}

- (CGRect) rectForKey: (NSString *) key {
    return [self.packedRects[key] rect];
}

- (CGSize) packedSize {
    return self.root.rect.size;
}

@end

@implementation PackedRect

- (float) longestDimension {
    return MAX(self.rect.size.width, self.rect.size.height);
}

- (float) area {
    return self.rect.size.width * self.rect.size.height;
}

// Order by longest dimension descending, then area descending
- (NSComparisonResult) compareTo: (PackedRect *) other {
    if ([self longestDimension] > [other longestDimension]) {
        return NSOrderedAscending;
    } else if ([self longestDimension] < [other longestDimension]) {
        return NSOrderedDescending;
    } else {
        if ([self area] > [other area]) {
            return NSOrderedAscending;
        } else if ([self area] < [other area]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }
}

- (BOOL) isBranch {
    return _leftChild != nil && _rightChild != nil;
}

- (void) updateOccupied {
    _occupied = _occupied || (_leftChild.occupied && _rightChild.occupied);
}

- (BOOL) insert: (PackedRect *) child {
    if (_occupied) {
        return NO;
    }

    if (_leftChild != nil && _rightChild != nil) {
        if ([_leftChild insert: child]) {
            [self updateOccupied];
            return YES;
        } else if ([_rightChild insert: child]) {
            [self updateOccupied];
            return YES;
        } else {
            return NO;
        }
    } else { // we're a leaf
        
        // doesn't fit
        if (child.rect.size.width > _rect.size.width || child.rect.size.height > _rect.size.height) {
            return NO;
        }
        
        // fits exactly
        if (child.rect.size.width == _rect.size.width && child.rect.size.height == _rect.size.height) {
            child.rect = _rect;
            //NSLog(@"Added child with rect: %@", NSStringFromCGRect(self.rect));
            _occupied = YES;
            return YES;
        }
        
        // Split the rect
        _leftChild = [[PackedRect alloc] init];
        _rightChild = [[PackedRect alloc] init];
        
        // Decide which way to split
        float dw = _rect.size.width - child.rect.size.width;
        float dh = _rect.size.height - child.rect.size.height;
        
        if (dw > dh) { // split left-right
            _leftChild.rect = CGRectMake(self.rect.origin.x,
                                             self.rect.origin.y,
                                             child.rect.size.width,
                                             self.rect.size.height);
            _rightChild.rect = CGRectMake(self.rect.origin.x + child.rect.size.width,
                                              self.rect.origin.y,
                                              self.rect.size.width - child.rect.size.width,
                                              self.rect.size.height);
        } else { // split top-bottom
            _leftChild.rect = CGRectMake(self.rect.origin.x,
                                             self.rect.origin.y,
                                             self.rect.size.width,
                                             child.rect.size.height);
            _rightChild.rect = CGRectMake(self.rect.origin.x,
                                              self.rect.origin.y + child.rect.size.height,
                                              self.rect.size.width,
                                              self.rect.size.height - child.rect.size.height);
        }
        
        // Insert the child into the left child
        if([_leftChild insert: child]) {
            [self updateOccupied];
            return YES;
        } else {
            return NO;
        }
        
    }
}


@end
