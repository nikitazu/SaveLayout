//
//  AppDelegate.h
//  SaveLayout
//
//  Created by Никита Зуев on 15.07.12.
//  Copyright (c) 2012 nikitazu@gmail.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "SLData.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSComboBox*    _sourcesBox;
    IBOutlet NSScrollView*  _savedSourcesView;
    IBOutlet NSButton*      _startMinimizedButton;
    IBOutlet NSButton*      _okButton;
    
    SLData* _data;
}

- (IBAction)onOkButtonPress:(id)sender;
- (IBAction)onStartMinimizedButtonPress:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
