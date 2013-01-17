#import "Kiwi.h"
#import "CZGRectanglePacker.h"

SPEC_BEGIN(CZGRectanglePackerSpec)

describe(@"CZGRectanglePacker", ^{
    registerMatchers(@"BG"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"a state the component is in", ^{
        __block id variable = nil;
        
        beforeAll(^{ // Occurs once
        });
        
        afterAll(^{ // Occurs once
        });
        
        beforeEach(^{ // Occurs before each enclosed "it"
            variable = @"Foo";
        });
        
        afterEach(^{ // Occurs after each enclosed "it"
        });
        
        it(@"should do something", ^{
            [[variable should] equal: @"Bar"];
        });
        
        specify(^{
            [variable shouldNotBeNil];
        });
        
        context(@"inner context", ^{
            it(@"does another thing", ^{
            });
            
            pending(@"something unimplemented", ^{
            });
        });
    });
});

SPEC_END