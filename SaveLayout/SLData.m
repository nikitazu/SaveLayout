//
//  SLData.m
//  SaveLayout
//
//  Created by Никита Зуев on 15.07.12.
//  Copyright (c) 2012 nikitazu@gmail.com. All rights reserved.
//

#import "SLData.h"

@implementation SLData

- (id) init 
{
    self = [super init];
    if (self) {
        
        _activeApplication = @"SaveLayout";
        
        NSDictionary *original = [NSDictionary dictionaryWithObject:(id)kTISCategoryKeyboardInputSource
                                                             forKey:(id)kTISPropertyInputSourceCategory];
        
        CFDictionaryRef dict = (__bridge CFDictionaryRef)original;
        
        _inputSources = TISCreateInputSourceList( dict, false );
        CFRetain( _inputSources );
        logInputSources( _inputSources );
        
        _savedInputSources = [NSMutableDictionary dictionary];
        _startMinimized = NO;
    }
    return self;
}

- (void)dealloc
{
    CFRelease( _inputSources );
}

- (void) changeActiveApplication:(NSString*)name
{
    NSLog(@"changeActiveApplication: name=%@", name);
    
    _activeApplication = name;
    
    int index = [self getInputSourceIndexOf:name];
    [self activateInputSourceAt:index];
}

- (void) changeActiveInputSource
{
    NSLog(@"changeActiveInputSource");
    
    int index = [self getInputSourceIndexOf:_activeApplication] + 1;
    
    if (index >= CFArrayGetCount(_inputSources)) { index = 0; }
    
    [self saveInputSourceAt:index of:_activeApplication];
}

- (void) save
{
    NSLog(@"saving preferences...");
    
    NSString*               path    = [SL_PREFERENCES_PATH stringByExpandingTildeInPath];
    NSMutableDictionary*    prefs   = [NSMutableDictionary dictionary];
    
    [prefs setObject:[NSNumber numberWithBool:_startMinimized] 
              forKey:SL_PKEY_START_MINIMIZED];
    
    [prefs setObject:_savedInputSources 
              forKey:SL_PKEY_INPUT_SOURCES];
    
    if ([prefs writeToFile:path atomically:YES]) {
        NSLog(@"preferences saved in: %@", path);
    }
}

- (void) load
{
    NSLog(@"loading preferences...");
    
    NSString*       path    = [SL_PREFERENCES_PATH stringByExpandingTildeInPath];
    NSDictionary*   prefs   = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if (prefs) {
        _savedInputSources  = [prefs objectForKey:SL_PKEY_INPUT_SOURCES];
        _startMinimized     = [[prefs objectForKey:SL_PKEY_START_MINIMIZED] boolValue];
        
        NSLog(@"preferences loaded from: %@", path);
    }
}


- (NSArray*) getInputSourcesNames
{
    NSMutableArray* temp = [NSMutableArray array];
    
    for (int i = 0; i < CFArrayGetCount(_inputSources); i++) {
        
        TISInputSourceRef   source  = (TISInputSourceRef)CFArrayGetValueAtIndex( _inputSources, i );
        CFStringRef         name    = TISGetInputSourceProperty( source, kTISPropertyLocalizedName );
        
        [temp addObject: (__bridge NSString*) name];
    }
    
    return temp;
}


- (BOOL) startMinimized
{
    return _startMinimized;
}

- (void) setStartMinimized:(BOOL)value
{
    _startMinimized = value;
}


// private

- (int) getInputSourceIndexOf:(NSString*)name
{
    NSLog(@"getInputSourceIndexOf: name=%@", name);
    id source = [_savedInputSources objectForKey:name];
    if (source) {
        return [source intValue];
    } else {
        return 0;
    }
}

- (void) activateInputSourceAt:(int)index
{
    NSLog(@"activateInputSourceAt: index=%i", index);
    TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex( _inputSources, index );
    
    OSStatus status = TISSelectInputSource( source );
    if (status != noErr) {
        NSLog(@"ERROR: activateInputSourceAt: index=%i; STATUS=%i", index, status);
    }
}

- (void) saveInputSourceAt:(int)index of:(NSString*)name
{
    NSLog(@"saveInputSourceAt: index=%i of: name=%@", index, name);
    [_savedInputSources setObject:[NSNumber numberWithInt:index] 
                           forKey:name];
}

void logInputSources(CFArrayRef sources)
{
    for (int i = 0; i < CFArrayGetCount(sources); i++) {
        TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex( sources, i );
        
        CFStringRef name = TISGetInputSourceProperty( source, kTISPropertyLocalizedName );
        
        NSLog(@"input source at: %i is: %@", i, name);
    }
}

@end
