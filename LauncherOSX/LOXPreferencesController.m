//
//  LOXPreferencesController.m
//  LauncherOSX
//
//  Created by Boris Schneiderman on 2013-07-16.
//  Copyright (c) 2013 Boris Schneiderman. All rights reserved.
//

#import "LOXPreferencesController.h"
#import "LOXPreferences.h"
#import "LOXSampleStylesProvider.h"
#import "LOXCSSStyle.h"
#import "LOXWebViewController.h"
#import "LOXCSSParser.h"
#import "LOXUtil.h"

#import "LOXMediaOverlay.h"

@interface LOXPreferencesController ()
- (LOXCSSStyle *)selectedStyle;

- (void)updateStylesUI;
@end

@implementation LOXPreferencesController {
    LOXPreferences *_preferences;
    LOXSampleStylesProvider *_stylesProvider;
}

- (IBAction)onClose:(id)sender
{
    [self closeSheet];
}

- (IBAction)applySkippables:(id)sender
{
    NSString* str = [self.moSkippablesCtrl string];
    //[self.webViewController setMediaOverlaySkippables:str];
    
    [_preferences updateMediaOverlaysSkippables: str];
}

- (IBAction)resetSkippables:(id)sender
{
    NSString* list = [LOXMediaOverlay defaultSkippables];
    [self.moSkippablesCtrl setString:list];
    
    NSString* str = [NSString stringWithUTF8String:""];
    //[self.webViewController setMediaOverlaySkippables:str];
    
    [_preferences updateMediaOverlaysSkippables: str];
}

- (IBAction)applyEscapables:(id)sender
{
    NSString* str = [self.moEscapablesCtrl string];
    //[self.webViewController setMediaOverlayEscapables:str];
    
    [_preferences updateMediaOverlaysEscapables: str];
}

- (IBAction)resetEscapables:(id)sender
{
    NSString* list = [LOXMediaOverlay defaultEscapables];
    [self.moEscapablesCtrl setString:list];
    
    NSString* str = [NSString stringWithUTF8String:""];
    //[self.webViewController setMediaOverlayEscapables:str];

    [_preferences updateMediaOverlaysEscapables: str];
}

- (IBAction)onApplyStyle:(id)sender
{
    LOXCSSStyle *style = [self selectedStyle];
    if(!style) {
        return;
    }

    NSString* block = [self.styleCtrl string];
    NSError *error = NULL;
    NSDictionary *declarations = [LOXCSSParser parseDeclarationsString:block error:&error];

    if(error) {

        NSString* msg = [NSString stringWithFormat:@"Parsing error: %@", error.localizedDescription];
        [LOXUtil reportError:msg];

        return;
    }

    style.declarationsBlock = block;
    style.declarations = declarations;

    [self.webViewController setStyles:[NSArray arrayWithObject:style]];
}

-(LOXCSSStyle *)selectedStyle
{
    int ix = [self.selectorsCtrl indexOfSelectedItem];
    if(ix == -1) {
        return nil;
    }

    return [_stylesProvider styleForIndex:ix];
}

- (IBAction)selectorSelected:(id)sender
{
    LOXCSSStyle *style = [self selectedStyle];

    if(style) {
        [self.styleCtrl setString: style.declarationsBlock];;
    }
}

- (IBAction)clearStyles:(id)sender
{
    [self.webViewController resetStyles];
}


- (void)showPreferences:(LOXPreferences *)preferences
{
    if(self.sheet) {
        return;
    }

    _preferences = preferences;
    [_preferences retain];


    //Make sure that in nib file "Visible at launch" property set to false
    //otherwise sheet il not be attached to the window
    [NSBundle loadNibNamed:@"PreferencesDlg" owner:self];

    [NSApp beginSheet:self.sheet
       modalForWindow:[[NSApp delegate] window]
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];

    [self updateStylesUI];
    
    if ([[[_preferences mediaOverlaysSkippables] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        NSString* list1 = [LOXMediaOverlay defaultSkippables];
        [self.moSkippablesCtrl setString:list1];
    }
    else
    {
        [self.moSkippablesCtrl setString:[_preferences mediaOverlaysSkippables]];
    }
    
    if ([[[_preferences mediaOverlaysEscapables] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        NSString* list2 = [LOXMediaOverlay defaultEscapables];
        [self.moEscapablesCtrl setString:list2];
    }
    else
    {
        [self.moEscapablesCtrl setString:[_preferences mediaOverlaysEscapables]];
    }
}

-(void)updateStylesUI
{
    [_stylesProvider release];
    _stylesProvider = [[LOXSampleStylesProvider alloc] init];
    [_stylesProvider retain];

    [self.selectorsCtrl removeAllItems];

    for(LOXCSSStyle *style in [_stylesProvider styles]) {
        [self.selectorsCtrl addItemWithTitle:style.selector];
    }

    [self.selectorsCtrl selectItemAtIndex:0];

    [self selectorSelected: self];
}

- (void)closeSheet
{
    if(!self.sheet) {
        return;
    }

    [_preferences release];
    [NSApp endSheet:self.sheet];
    [self.sheet close];
    self.sheet = nil;
}


- (void)dealloc {
    [_preferences release];
    [_stylesProvider release];
    [super dealloc];
}


@end
