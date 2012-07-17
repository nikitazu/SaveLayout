//
//  AppDelegate.m
//  SaveLayout
//
//  Created by Никита Зуев on 15.07.12.
//  Copyright (c) 2012 nikitazu@gmail.com. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"start");
    
    _data = [SLData new];
    [_data load];
    
    [_window setIsMiniaturized: [_data startMinimized]];
    if ([_data startMinimized]) {
        [_startMinimizedButton setState: NSOnState];
    } else {
        [_startMinimizedButton setState: NSOffState];
    }
    
    [_sourcesBox addItemsWithObjectValues:[_data getInputSourcesNames]];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] 
     addObserver:self
     selector:@selector(wsNotificationHook:)
     name:NSWorkspaceDidActivateApplicationNotification 
     object:nil];
    
    EventHotKeyRef myHotKeyRef;
    EventHotKeyID myHotKeyID;
    EventTypeSpec eventType;
    
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    
    InstallApplicationEventHandler(&MyHotKeyHandler,1,&eventType,(__bridge void*)_data,NULL);
    
    myHotKeyID.signature='mhk1';
    myHotKeyID.id=1;
    
    RegisterEventHotKey(49, cmdKey, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
}

- (void)wsNotificationHook:(NSNotification *)note
{
    NSDictionary* info = [note userInfo];
    NSRunningApplication* app = [info objectForKey:@"NSWorkspaceApplicationKey"];
    
    NSLog(@"activated: %@", [app localizedName]);
    
    [_data changeActiveApplication: [app localizedName]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
    [_data save];
}


- (IBAction) onOkButtonPress:(id)sender
{
    [_data save];
    [_window setIsMiniaturized:YES];
}


- (IBAction)onStartMinimizedButtonPress:(id)sender
{
    [_data setStartMinimized: [_startMinimizedButton state] == NSOnState];
    [_data save];
}

OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,
                         EventRef theEvent,
                         void *userData)
{
    EventHotKeyID hkCom;
    GetEventParameter(theEvent,
                      kEventParamDirectObject,
                      typeEventHotKeyID,
                      NULL,
                      sizeof(hkCom),
                      NULL,
                      &hkCom);
    int l = hkCom.id;
    SLData* data = (__bridge SLData*)userData;
    
    switch (l) {
        case 1:
            [data changeActiveInputSource];
            break;
    }
    return noErr;
}

@end
