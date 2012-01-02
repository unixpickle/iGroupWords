//
//  SplitPhrase.h
//  WordBalance
//
//  Created by Alex Nichol on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SplitPhraseTypeCharacters,
    SplitPhraseTypeWords
} SplitPhraseType;

@interface SplitPhrase : NSObject {
    NSArray * leftGroup;
    NSArray * rightGroup;
    CGFloat leftWidth;
    CGFloat rightWidth;
    SplitPhraseType phraseType;
}

@property (readonly) NSArray * leftGroup;
@property (readonly) NSArray * rightGroup;
@property (readonly) CGFloat leftWidth;
@property (readonly) CGFloat rightWidth;
@property (readonly) SplitPhraseType phraseType;

+ (NSArray *)stringsFromString:(NSString *)string splitType:(SplitPhraseType)aType;
+ (NSString *)joinStrings:(NSArray *)strings splitType:(SplitPhraseType)aType;

- (id)initWithLeft:(NSArray *)left right:(NSArray *)right phraseType:(SplitPhraseType)aType;
- (CGFloat)differenceMargin;

- (NSArray *)possibleMutations;
+ (SplitPhrase *)splitPhraseFromString:(NSString *)aString splitType:(SplitPhraseType)aType;

- (NSString *)leftString;
- (NSString *)rightString;

@end
