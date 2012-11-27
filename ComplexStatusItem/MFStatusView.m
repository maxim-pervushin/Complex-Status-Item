//
//  MFStatusView.m
//  ComplexStatusItem
//
//  Created by Maxim Pervushin on 11/27/12.
//  Copyright (c) 2012 Maxim Pervushin. All rights reserved.
//

#import "MFStatusView.h"

#define ImageViewWidth 22
#define ToggleImageViewWidth 22

@interface MFStatusView ()
{
    BOOL _active;
    BOOL _checked;
    
    NSImageView *_imageView;
    NSImageView *_toggleImageView;
    
    NSStatusItem *_statusItem;
    NSMenu *_statusItemMenu;
}

- (void)updateUI;
- (void)setActive:(BOOL)active;
- (void)toggle;
- (void)setChecked:(BOOL)checked;

- (void)firstMenuItemAction:(id)sender;
- (void)secondMenuItemAction:(id)sender;
- (void)quitMenuItemAction:(id)sender;

@end

@implementation MFStatusView

- (id)init
{
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    self = [super initWithFrame:NSMakeRect(0, 0, ImageViewWidth, height)];
    if (self) {
        
        _active = NO;
        _checked= NO;
        
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, ImageViewWidth, height)];
        _imageView.image = [NSImage imageNamed:@"mf-image-black"];
        [self addSubview:_imageView];

        _toggleImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(ToggleImageViewWidth, 0, ToggleImageViewWidth, height)];
        _toggleImageView.image = [NSImage imageNamed:@"button-off"];
        [self addSubview:_toggleImageView];

        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:(ImageViewWidth + ToggleImageViewWidth)];
        _statusItem.view = self;
        
        _statusItemMenu = [[NSMenu alloc] init];
        _statusItemMenu.delegate = self;
        _statusItemMenu.autoenablesItems = NO;
        _statusItem.menu = _statusItemMenu;
        
        NSMenuItem *menuItem1 = [[NSMenuItem alloc] initWithTitle:@"First" action:@selector(firstMenuItemAction:) keyEquivalent:@""];
        menuItem1.target = self;
        [menuItem1 setEnabled:YES];
        [_statusItemMenu addItem:menuItem1];
        
        NSMenuItem *menuItem2 = [[NSMenuItem alloc] initWithTitle:@"Second" action:@selector(secondMenuItemAction:) keyEquivalent:@""];
        menuItem2.target = self;
        [menuItem2 setEnabled:YES];
        [_statusItemMenu addItem:menuItem2];

        [_statusItemMenu addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quitMenuItemAction:) keyEquivalent:@""];
        quitItem.target = self;
        [quitItem setEnabled:YES];
        [_statusItemMenu addItem:quitItem];

    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (_active) {
        [[NSColor selectedMenuItemColor] setFill];
        NSRectFill(dirtyRect);
    } else {
        [[NSColor clearColor] setFill];
        NSRectFill(dirtyRect);
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint point = [theEvent locationInWindow];
    if (NSPointInRect(point, _toggleImageView.frame)) {
        [self toggle];
    } else {
        [self setActive:YES];
        [_statusItem popUpStatusItemMenu:_statusItemMenu];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [self setActive:NO];
}

- (void)updateUI
{
    _imageView.image = [NSImage imageNamed:_active ? @"mf-image-white" : @"mf-image-black"];
    if (_checked) {
        _toggleImageView.image = [NSImage imageNamed:_active ? @"button-on-white" : @"button-on-black"];
        
    } else {
        _toggleImageView.image = [NSImage imageNamed:_active ? @"button-off-white" : @"button-off-black"];
    }
    [self setNeedsDisplay:YES];
}

- (void)setActive:(BOOL)active
{
    _active = active;
    [self updateUI];
}

- (void)toggle
{
    [self setChecked:!_checked];
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    [self updateUI];
}

- (void)firstMenuItemAction:(id)sender
{
    NSLog(@"First Menu Item Selected");
}

- (void)secondMenuItemAction:(id)sender
{
    NSLog(@"Second Menu Item Selected");
}

- (void)quitMenuItemAction:(id)sender
{
    [[NSApplication sharedApplication] terminate:self];
}

#pragma mark - NSMenuDelegate

- (void)menuDidClose:(NSMenu *)menu
{
    [self setActive:NO];
}

@end
