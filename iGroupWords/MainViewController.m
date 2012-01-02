//
//  MainViewController.m
//  iGroupWords
//
//  Created by Alex Nichol on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

static SplitPhraseType splitTypeForPhrase (NSString * aPhrase);

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    pile1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 95, 300, 30)];
    pile2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, 300, 30)];
    
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    groupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [groupButton setTitle:@"Group" forState:UIControlStateNormal];
    [groupButton setFrame:CGRectMake(200, 50, 110, 35)];
    [groupButton addTarget:self action:@selector(groupTapped:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [pile1 setBorderStyle:UITextBorderStyleLine];
    [pile2 setBorderStyle:UITextBorderStyleLine];
    
    [loadingIndicator setCenter:CGPointMake(150, 67.5)];
    
    [self.view addSubview:textField];
    [self.view addSubview:pile1];
    [self.view addSubview:pile2];
    [self.view addSubview:groupButton];
    [self.view addSubview:loadingIndicator];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Grouping -

- (IBAction)groupTapped:(id)sender {
    if (backgroundThread) {
        [backgroundThread cancel];
        backgroundThread = nil;
        [groupButton setTitle:@"Group" forState:UIControlStateNormal];
        [loadingIndicator stopAnimating];
    } else {
        [groupButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [loadingIndicator startAnimating];
        backgroundThread = [[NSThread alloc] initWithTarget:self selector:@selector(groupMethod:)
                                                     object:[textField text]];
        [backgroundThread start];
    }
}

- (void)groupMethod:(NSString *)theString {
    @autoreleasepool {
        SplitPhraseType type = splitTypeForPhrase(theString);
        
        SplitPhrase * original = [SplitPhrase splitPhraseFromString:theString
                                                          splitType:type];
        
        SplitPhrase * bestPhrase = original;
        NSMutableArray * queue = [[NSMutableArray alloc] initWithObjects:original, nil];
        NSUInteger totalSearched = 0;
        
        while ([queue count] > 0) {
            if ([[NSThread currentThread] isCancelled]) return;
            SplitPhrase * aPhrase = [queue objectAtIndex:0];
            [queue removeObjectAtIndex:0];
            if ([aPhrase differenceMargin] < [bestPhrase differenceMargin]) {
                bestPhrase = aPhrase;
            }
            totalSearched++;
            if (totalSearched < 500) {
                [queue addObjectsFromArray:[aPhrase possibleMutations]];
            }
        }
        
        if (![[NSThread currentThread] isCancelled]) {
            [self performSelectorOnMainThread:@selector(groupCallback:)
                                   withObject:bestPhrase
                                waitUntilDone:NO];
        }
    }
}

- (void)groupCallback:(SplitPhrase *)aPhrase {
    [loadingIndicator stopAnimating];
    backgroundThread = nil;
    [groupButton setTitle:@"Group" forState:UIControlStateNormal];
    [pile1 setText:[aPhrase leftString]];
    [pile2 setText:[aPhrase rightString]];
}

@end

static SplitPhraseType splitTypeForPhrase (NSString * aPhrase) {
    NSArray * words = [aPhrase componentsSeparatedByString:@" "];
    if ([words count] > 2) return SplitPhraseTypeWords;
    return SplitPhraseTypeCharacters;
}
