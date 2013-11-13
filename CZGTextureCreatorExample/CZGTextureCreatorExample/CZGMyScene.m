//
//  CZGMyScene.m
//  CZGTextureCreatorExample
//
//  Created by Liam Cain on 11/6/13.
//  Copyright (c) 2013 Zworkbench Inc. All rights reserved.
//

#import "CZGMyScene.h"
#import "CZGTextureCreator.h"
#import "DTCoreText.h"

@implementation CZGMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        CZGTextureCreator *textureCreator = [[CZGTextureCreator alloc] init];

        // Core Graphics drawing example
        [textureCreator addFrameWithName: @"redRectangle"
                                    size: CGSizeMake(100,50)
                            drawingBlock: ^(CGRect rect, CGContextRef ctx) {
                                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: CGRectInset(rect, 2.0, 2.0) cornerRadius: 10.0];
                                path.lineWidth = 2.0;
                                CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
                                CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
                                [path fill];
                                [path stroke];
                            }];
        
        // Simple text drawing
        [textureCreator addFrameWithName: @"howdy"
                                    size: CGSizeMake(100,20)
                            drawingBlock: ^(CGRect rect, CGContextRef ctx) {
                                NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize: 15.0],
                                                             NSForegroundColorAttributeName: [UIColor whiteColor],
                                                             NSParagraphStyleAttributeName: [NSParagraphStyle defaultParagraphStyle]};
                                [@"howdy" drawInRect:rect withAttributes:attributes];
                            }];
        

        
        // CZGTextureCreator uses DTCoreText to provide an HTML convenience method.
        // Here's an example of creating a single label frame that has formatted HTML text
        textureCreator.defaultTextOptions =  @{  DTDefaultFontFamily : @"Futura",
                                                 DTDefaultTextColor  : @"white"};
        [textureCreator addFrameWithName: @"html"
                                    size: CGSizeMake(320,200)
                                htmlText: @"<span style=\"font-size: 16;\">Unladen swallow ground speed: <b>32</b> <i>mph</i></span>"];
        
        [textureCreator createTexture];
        
        CGSize howdySize = CGSizeMake([textureCreator textureNamed:@"howdy"].size.width/2, [textureCreator textureNamed:@"howdy"].size.height/2);
		SKSpriteNode *howdy = [SKSpriteNode spriteNodeWithTexture:[textureCreator textureNamed:@"howdy"] size:howdySize];
        howdy.position = CGPointMake(150,300);
        [self addChild: howdy];

        SKSpriteNode *redRectangle = [SKSpriteNode spriteNodeWithTexture:[textureCreator textureNamed:@"redRectangle"]];
        redRectangle.position = CGPointMake(150,200);
        [self addChild: redRectangle];
        
        SKSpriteNode *wholeTexture = [SKSpriteNode spriteNodeWithTexture:textureCreator.mainTexture];
        [self addChild:wholeTexture];
        wholeTexture.position = CGPointMake(160, 450);
//        [wholeTexture setScale:.25];
        
        SKSpriteNode *html = [SKSpriteNode spriteNodeWithTexture:[textureCreator textureNamed:@"html"]];
        html.position = CGPointMake(160.0, 100.0);
        [self addChild: html];
//        [html setScale:.6f];
    }
    return self;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
//}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
