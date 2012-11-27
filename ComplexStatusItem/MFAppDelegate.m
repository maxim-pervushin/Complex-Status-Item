//
//  MFAppDelegate.m
//  ComplexStatusItem
//
//  Created by Maxim Pervushin on 11/27/12.
//  Copyright (c) 2012 Maxim Pervushin. All rights reserved.
//

#import "MFAppDelegate.h"
#import "MFStatusView.h"

@interface MFAppDelegate ()
{
    MFStatusView *_statusView;
}

@end

@implementation MFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _statusView = [[MFStatusView alloc] init];
}

@end
