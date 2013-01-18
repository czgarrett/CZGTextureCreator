CZGTextureCreator
=================

CZGTextureCreator is a cocos2d-based class that allows you to draw multiple images, then packs them into a single CCTexture so that they can be used in batch nodes.

Overview:
---

CZGTextureCreator serves two main purposes.  

First, it allows drawing of texture frames using Core Graphics.  CZGTextureCreator will take a batch of drawn frames and pack them into a single texture that can be used in sprites.  

Second, it uses Core Text (via the DTCoreText pod) to create properly typeset text sprites.  CCLabelTTF is too slow to update and limited to single font labels.  CCLabelBMFont or CCLabelAtlas are faster, but they don't lay text out properly.  Instead they treat text as though it were blocks of images, which it is not.  Don't [steal sheep](http://www.amazon.com/Stop-Stealing-Sheep-Find-Works/dp/0201703394)!

The only time you wouldn't want to use CZGTextureCreator with text is if you are rapidly changing text, such as in a rapidly changing score counter.  Any other time, this should be significantly faster, a better use of resources, and easier on designers' eyes than the standard Cocos2d labels.


Installation:
---

CZGTextureCreator is wrapped up as a [cocoapod](cocoapods.org).  The easiest way to use it is to add it as a pod to your project.  CZGTextureCreator depends on cocos2d being installed as a pod.  If you haven't done this, I recommend adding cocos2d as a pod to your existing project, then delete the cocos2d files that were added when you set up the project.

Example:
---
```objective-c
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

	// Texture creator will then pack the above frames and call the draw blocks for each one.  It will also add the frame names to the texture frame cache.
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
```
