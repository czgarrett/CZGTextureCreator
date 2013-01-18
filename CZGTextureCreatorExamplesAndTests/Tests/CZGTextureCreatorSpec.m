#import "Kiwi.h"
#import "CZGTextureCreator.h"

SPEC_BEGIN(CZGTextureCreatorSpec)

describe(@"CZGTextureCreator", ^{
    registerMatchers(@"BG"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"an instance with three images in it", ^{
        __block CZGTextureCreator *textureCreator;
        
        beforeAll(^{ // Occurs once
        });
        
        afterAll(^{ // Occurs once
        });
        
        beforeEach(^{ // Occurs before each enclosed "it"
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
        });
        
        it(@"should create a texture for those images", ^{
        });
        
        it(@"should be able to create a CCSprite with that texture", ^{
            
        });
        
    });
});

SPEC_END