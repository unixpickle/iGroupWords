//
//  SplitPhrase.m
//  WordBalance
//
//  Created by Alex Nichol on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplitPhrase.h"

@implementation SplitPhrase

@synthesize leftGroup;
@synthesize rightGroup;
@synthesize leftWidth;
@synthesize rightWidth;
@synthesize phraseType;

+ (NSArray *)stringsFromString:(NSString *)string splitType:(SplitPhraseType)aType {
    switch (aType) {
        case SplitPhraseTypeCharacters:
        {
            NSMutableArray * characterArray = [NSMutableArray array];
            for (NSUInteger i = 0; i < [string length]; i++) {
                [characterArray addObject:[string substringWithRange:NSMakeRange(i, 1)]];
            }
            return [NSArray arrayWithArray:characterArray];
            break;
        }
        case SplitPhraseTypeWords:
            return [string componentsSeparatedByString:@" "];
            break;
        default:
            break;
    }
    return nil;
}

+ (NSString *)joinStrings:(NSArray *)strings splitType:(SplitPhraseType)aType {
    switch (aType) {
        case SplitPhraseTypeWords:
        {
            NSMutableString * joined = [NSMutableString string];
            for (NSUInteger i = 0; i < [strings count]; i++) {
                [joined appendFormat:@"%@", [strings objectAtIndex:i]];
                if (i + 1 != [strings count]) {
                    [joined appendFormat:@" "];
                }
            }
            return [NSString stringWithString:joined];
            break;
        }
        case SplitPhraseTypeCharacters:
        {
            NSMutableString * joined = [NSMutableString string];
            for (NSUInteger i = 0; i < [strings count]; i++) {
                [joined appendFormat:@"%@", [strings objectAtIndex:i]];
            }
            return [NSString stringWithString:joined];
            break;
        }
        default:
            break;
    }
    return nil;
}

- (id)initWithLeft:(NSArray *)left right:(NSArray *)right phraseType:(SplitPhraseType)aType {
    if ((self = [super init])) {
        phraseType = aType;
        leftGroup = left;
        rightGroup = right;
        
        NSString * leftString = [[self class] joinStrings:leftGroup splitType:aType];
        NSString * rightString = [[self class] joinStrings:rightGroup splitType:aType];
        
        UIFont * font = [UIFont systemFontOfSize:12];
        
        leftWidth = [leftString sizeWithFont:font].width;
        rightWidth = [rightString sizeWithFont:font].width;
    }
    return self;
}

- (CGFloat)differenceMargin {
    return ABS(leftWidth - rightWidth);
}

- (NSArray *)possibleMutations {
    NSMutableArray * mutations = [[NSMutableArray alloc] init];
    
    // move every possible token from the left to the right
    for (NSUInteger i = 0; i < [leftGroup count]; i++) {
        NSString * theToken = [leftGroup objectAtIndex:i];
        
        NSMutableArray * mutableLeft = [leftGroup mutableCopy];
        [mutableLeft removeObjectAtIndex:i];
        NSArray * newRight = [rightGroup arrayByAddingObject:theToken];
        NSArray * newLeft = [NSArray arrayWithArray:mutableLeft];
        
        [mutations addObject:[[SplitPhrase alloc] initWithLeft:newLeft
                                                         right:newRight
                                                    phraseType:phraseType]];
    }
    
    // move every possible token from the right to the left
    for (NSUInteger i = 0; i < [rightGroup count]; i++) {
        NSString * theToken = [rightGroup objectAtIndex:i];
        
        NSMutableArray * mutableRight = [rightGroup mutableCopy];
        [mutableRight removeObjectAtIndex:i];
        NSArray * newLeft = [leftGroup arrayByAddingObject:theToken];
        NSArray * newRight = [NSArray arrayWithArray:mutableRight];
        
        [mutations addObject:[[SplitPhrase alloc] initWithLeft:newLeft
                                                         right:newRight
                                                    phraseType:phraseType]];
    }
    
    return [NSArray arrayWithArray:mutations];
}

+ (SplitPhrase *)splitPhraseFromString:(NSString *)aString splitType:(SplitPhraseType)aType {
    SplitPhrase * phrase = nil;
    NSArray * tokens = [[self class] stringsFromString:aString splitType:aType];
    for (NSUInteger i = 0; i < [tokens count]; i++) {
        // split the string in two
        NSArray * leftGroup = [tokens subarrayWithRange:NSMakeRange(0, i)];
        NSArray * rightGroup = [tokens subarrayWithRange:NSMakeRange(i, ([tokens count] - i))];
        // find the best phrase
        SplitPhrase * aPhrase = [[SplitPhrase alloc] initWithLeft:leftGroup
                                                            right:rightGroup
                                                       phraseType:aType];
        if ([aPhrase differenceMargin] < [phrase differenceMargin] || !phrase) {
            phrase = aPhrase;
        }
    }
    return phrase;
}

- (NSString *)leftString {
    return [[self class] joinStrings:leftGroup splitType:phraseType];
}

- (NSString *)rightString {
    return [[self class] joinStrings:rightGroup splitType:phraseType];
}

@end
