#import "Kiwi.h"
#import "CZGRectanglePacker.h"

SPEC_BEGIN(CZGRectanglePackerSpec)

describe(@"CZGRectanglePacker", ^{
    registerMatchers(@"BG"); // Registers BGTangentMatcher, BGConvexMatcher, etc.
    
    context(@"after adding 10 2048x2048 rects", ^{
        __block CZGRectanglePacker *packer;
        
        beforeEach(^{ // Occurs before each enclosed "it"
            packer = [[CZGRectanglePacker alloc] init];
            for (int i=0; i<10; i++) {
                [packer addRectangleWithSize: CGSizeMake(2048,2048) key: [NSString stringWithFormat: @"2048x2048-%d", i]];
            }
        });
        
        it(@"should fail to pack", ^{
            [[theValue([packer pack]) should] equal: theValue(NO)];
        });
    });
    
    context(@"after adding 10000 10x10 rects", ^{
        __block CZGRectanglePacker *packer;
        
        beforeEach(^{ // Occurs before each enclosed "it"
            packer = [[CZGRectanglePacker alloc] init];
            for (int i=0; i<10000; i++) {
                [packer addRectangleWithSize: CGSizeMake(10,10) key: [NSString stringWithFormat: @"10x10-%d", i]];
            }
        });
        
        it(@"should have a packed size of 1024x1024", ^{
            [packer pack];
            [[theValue([packer packedSize]) should] equal: theValue(CGSizeMake(1024,1024))];
        });
    });

    
    context(@"after packing rects of size 100x10, 10x90, and 50x50", ^{
        __block CZGRectanglePacker *packer;
        
        beforeAll(^{ // Occurs once
        });
        
        beforeEach(^{ // Occurs before each enclosed "it"
            packer = [[CZGRectanglePacker alloc] init];
            [packer addRectangleWithSize: CGSizeMake(100, 10) key: @"100x10"];
            [packer addRectangleWithSize: CGSizeMake(10, 90) key: @"10x90"];
            [packer addRectangleWithSize: CGSizeMake(50, 50) key: @"50x50"];
            [packer pack];
        });
        
        it(@"should have a packed size of 128x128", ^{
            [[theValue([packer packedSize]) should] equal: theValue(CGSizeMake(128,128))];
        });
        
        context(@" after adding three more 50x50 rects", ^{
            it(@"should still have a packed size of 128x128", ^{
                for (int i=0; i<3; i++) {
                    [packer addRectangleWithSize: CGSizeMake(50,50) key: [NSString stringWithFormat: @"50x50-%d", i]];
                }
                [packer pack];
                [[theValue([packer packedSize]) should] equal: theValue(CGSizeMake(128,128))];
            });
        });
        
    });
});

SPEC_END