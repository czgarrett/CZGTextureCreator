//
//  HelloWorldLayer.m
//  CZGTextureCreatorExamplesAndTests
//
//  Created by Christopher Garrett on 1/17/13.
//  Copyright ZWorkbench 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CZGRectanglePacker.h"
#import "CZGTextureCreator.h"
#import "DTCoreText.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
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
            CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
            [@"howdy" drawInRect: rect withFont: [UIFont boldSystemFontOfSize: 15.0]];
        }];
        
        // CZGTextureCreator uses DTCoreText to provide an HTML convenience method.
        // Here's an example of creating a single label frame that has formatted HTML text
        textureCreator.defaultTextOptions =  @{  DTDefaultFontFamily : @"Futura",
                                                 DTDefaultTextColor  : @"white"};
        [textureCreator addFrameWithName: @"html"
                                    size: CGSizeMake(320,200)
                                htmlText: @"<span style=\"font-size: 16;\">Unladen swallow ground speed: <b>32</b> <i>mph</i></span>"];

        CCTexture2D *texture = [textureCreator createTexture];
        
        // Create a batch node so that all sprites drawn from the texture are batched into one draw call
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithTexture: texture];

		CCSprite *howdy = [CCSprite spriteWithSpriteFrameName: @"howdy"];
        howdy.position = ccp(50,50);
        [batchNode addChild: howdy]; // don't forget to add the sprites to the batch node, not self

        CCSprite *redRectangle = [CCSprite spriteWithSpriteFrameName: @"redRectangle"];
        redRectangle.position = ccp(300,100);
        [batchNode addChild: redRectangle];

        CCSprite *html = [CCSprite spriteWithSpriteFrameName: @"html"];
        html.anchorPoint = ccp(1.0, 0.5);
        html.position = ccp(320.0, 200.0);
        [batchNode addChild: html];
        
        // Add the completed frame in the top left to see what it looks like:
        CCSprite *full = [CCSprite spriteWithTexture: texture rect: CGRectMake(0,0, texture.pixelsWide, texture.pixelsHigh)];
        full.anchorPoint = ccp(0, 1.0);
        full.position = ccp(0,300);
        full.scale = 0.5;
        [batchNode addChild: full];

        [self addChild: batchNode];

        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
