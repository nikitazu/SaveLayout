//
//  SLData.h
//  SaveLayout
//
//  Created by Никита Зуев on 15.07.12.
//  Copyright (c) 2012 nikitazu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

@interface SLData : NSObject
{
    CFArrayRef              _inputSources;
    NSString*               _activeApplication;
    NSMutableDictionary*    _savedInputSources;
}

- (void) changeActiveApplication:(NSString*)name;
- (void) changeActiveInputSource;
- (void) save;
- (void) load;
- (void) cleanUp;

- (NSArray*) getInputSourcesNames;

@end
