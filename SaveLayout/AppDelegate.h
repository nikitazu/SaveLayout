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
    IBOutlet NSComboBox* _sourcesBox;
    SLData* _data;
}

@property (assign) IBOutlet NSWindow *window;

@end
