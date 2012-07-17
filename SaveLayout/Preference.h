//
//  Preference.h
//  SaveLayout
//
//  Created by Никита Зуев on 17.07.12.
//  Copyright (c) 2012 nikitazu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// Path to save preferences of this application
FOUNDATION_EXPORT NSString *const SL_PREFERENCES_PATH;

// Key name to store/get preference whether application should start minimized
FOUNDATION_EXPORT NSString *const SL_PKEY_START_MINIMIZED;

// Key name to store/get preference with all changed applications' input sources
FOUNDATION_EXPORT NSString *const SL_PKEY_INPUT_SOURCES;
