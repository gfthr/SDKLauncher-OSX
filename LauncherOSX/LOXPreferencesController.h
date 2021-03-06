//
//  LOXPreferencesController.h
//  LauncherOSX
//
//  Created by Boris Schneiderman on 2013-07-16.
//  Copyright (c) 2013 Boris Schneiderman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LOXPreferences;
@class LOXWebViewController;

@interface LOXPreferencesController : NSObject

- (IBAction)onClose:(id)sender;
- (IBAction)onApplyStyle:(id)sender;
- (IBAction)selectorSelected:(id)sender;
- (IBAction)clearStyles:(id)sender;
- (IBAction)resetSkippables:(id)sender;
- (IBAction)resetEscapables:(id)sender;
- (IBAction)applySkippables:(id)sender;
- (IBAction)applyEscapables:(id)sender;

@property (assign) IBOutlet NSWindow *sheet;

@property (assign) IBOutlet NSPopUpButton *selectorsCtrl;
@property (assign) IBOutlet NSTextView *styleCtrl;
@property (assign) IBOutlet NSTextView *moSkippablesCtrl;
@property (assign) IBOutlet NSTextView *moEscapablesCtrl;

@property(nonatomic, retain) LOXPreferences *preferences;
@property(nonatomic, retain) LOXWebViewController *webViewController;

-(void) showPreferences:(LOXPreferences*)preferences;
-(void) closeSheet;

@end
