//
//  MainViewController.h
//  iGroupWords
//
//  Created by Alex Nichol on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitPhrase.h"

@interface MainViewController : UIViewController {
    UITextField * textField;
    UITextField * pile1;
    UITextField * pile2;
    UIActivityIndicatorView * loadingIndicator;
    UIButton * groupButton;
    
    NSThread * backgroundThread;
}

- (IBAction)groupTapped:(id)sender;

- (void)groupMethod:(NSString *)theString;
- (void)groupCallback:(SplitPhrase *)aPhrase;

@end
