//
//  KFToolbarItem.m
//  KFJSON
//
//  Created by rick on 25.02.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFToolbarItem.h"


static CGFloat kKFToolbarItemGradientLocations[] =     {0.0f, 0.5f, 1.0f};

#define kKFToolbarItemGradienColorTop [NSColor colorWithCalibratedWhite:0.7f alpha:0.0f]
#define kKFToolbarItemGradienColorBottom [NSColor colorWithCalibratedWhite:0.7f alpha:1.0f]
#define kKFToolbarItemGradien [[NSGradient alloc] initWithColors: [NSArray arrayWithObjects: \
kKFToolbarItemGradienColorTop, \
kKFToolbarItemGradienColorBottom, \
kKFToolbarItemGradienColorTop, nil] \
atLocations: kKFToolbarItemGradientLocations \
colorSpace: [NSColorSpace genericGrayColorSpace]]


@interface KFToolbarItemButtonCell : NSButtonCell

@property (nonatomic) NSButtonType buttonType;

@end


@interface KFToolbarItem ()


@property (nonatomic, strong) NSButton* tabBarItemButton;


@end


@implementation KFToolbarItem


+ (instancetype)toolbarItemWithType:(NSButtonType)type icon:(NSImage *)iconImage tag:(NSUInteger)itemTag
{
    return [[KFToolbarItem alloc] initWithButtonType:type icon:iconImage tag:itemTag];
}


+ (instancetype)toolbarItemWithIcon:(NSImage *)iconImage tag:(NSUInteger)itemTag
{
    return [[KFToolbarItem alloc] initWithIcon:iconImage tag:itemTag];
}


- (instancetype)initWithIcon:(NSImage *)iconImage tag:(NSUInteger)itemTag
{
    return [self initWithButtonType:NSMomentaryPushInButton icon:iconImage tag:itemTag];
}


- (instancetype)initWithButtonType:(NSButtonType)type icon:(NSImage *)iconImage tag:(NSUInteger)itemTag
{
    self = [super init];
    if (self)
    {
        self.tabBarItemButton = [[NSButton alloc] initWithFrame:NSZeroRect];
        
        KFToolbarItemButtonCell *cell = [[KFToolbarItemButtonCell alloc] init];
        cell.buttonType = type;
        cell.state = NSOffState;
        self.tabBarItemButton.cell = cell;
        
        [self.tabBarItemButton setButtonType:type];
        [self.tabBarItemButton setEnabled:YES];
        self.tabBarItemButton.image = iconImage;
        self.tabBarItemButton.tag = itemTag;
        [self.tabBarItemButton sendActionOn:NSLeftMouseDownMask];
    }
    return self;
}


- (void)removeFromSuperview
{
    [self.tabBarItemButton removeFromSuperview];
}


#pragma mark - Properties

- (void)setIcon:(NSImage *)newIcon
{
    self.tabBarItemButton.image = newIcon;
}


- (NSImage *)icon
{
    return self.tabBarItemButton.image;
}


- (void)setTag:(NSInteger)newTag
{
    self.tabBarItemButton.tag = newTag;
}


- (NSInteger)tag
{
    return self.tabBarItemButton.tag;
}


- (void)setToolTip:(NSString *)newToolTip
{
    self.tabBarItemButton.toolTip = newToolTip;
}


- (NSString *)toolTip
{
    return self.tabBarItemButton.toolTip;
}


- (void)setKeyEquivalentModifierMask:(NSUInteger)newKeyEquivalentModifierMask
{
    self.tabBarItemButton.keyEquivalentModifierMask = newKeyEquivalentModifierMask;
}


- (NSUInteger)keyEquivalentModifierMask
{
    return self.tabBarItemButton.keyEquivalentModifierMask;
}


- (void)setKeyEquivalent:(NSString *)newKeyEquivalent
{
    self.tabBarItemButton.keyEquivalent = newKeyEquivalent;
}

- (NSString *)keyEquivalent
{
    return self.tabBarItemButton.keyEquivalent;
}


- (void)setState:(NSInteger)value
{
    self.tabBarItemButton.state = value;
}


- (NSInteger)state
{
    return self.tabBarItemButton.state;
}


- (void)setButtonType:(NSButtonType)aType
{
    [self.tabBarItemButton setButtonType:aType];
}


@end


#pragma mark - KFToolbarItemButtonCell


@implementation KFToolbarItemButtonCell


- (id)init
{
    self = [super init];
    if (self)
    {
        self.state = NSOffState;
        self.bezelStyle = NSTexturedRoundedBezelStyle;
    }
    return self;
}


- (NSInteger)showsStateBy
{
    return 0;
}


- (NSInteger)highlightsBy
{
    return NSPushInCellMask;
}


- (NSInteger)nextState
{    
    switch (self.buttonType)
    {
        case NSToggleButton:
            return self.state == NSOnState ? NSOffState : NSOnState;
            break;
            
        default:
            return NSOffState;
            break;
    }
}


- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    if (self.isHighlighted || self.state == NSOnState)
    {
        [[NSGraphicsContext currentContext] saveGraphicsState];
        
        // Draw light vertical gradient
        [kKFToolbarItemGradien drawInRect:frame angle:90.0f];
        
        // Draw shadow on the left border of the item
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = NSMakeSize(1.0f, 0.0f);
        shadow.shadowBlurRadius = 2.0f;
        shadow.shadowColor = [NSColor darkGrayColor];
        [shadow set];
        
        [[NSColor blackColor] set];
        CGFloat radius = 50.0;
        NSPoint center = NSMakePoint(NSMinX(frame) - radius, NSMidY(frame));
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:center];
        [path appendBezierPathWithArcWithCenter:center radius:radius startAngle:-90.0f endAngle:90.0f];
        [path closePath];
        [path fill];
        
        // shadow of the right border
        shadow.shadowOffset = NSMakeSize(-1.0f, 0.0f);
        [shadow set];
        
        center = NSMakePoint(NSMaxX(frame) + radius, NSMidY(frame));
        path = [NSBezierPath bezierPath];
        [path moveToPoint:center];
        [path appendBezierPathWithArcWithCenter:center radius:radius startAngle:90.0f  endAngle:270.0f];
        [path closePath];
        [path fill];
        
        // Restore context
        [[NSGraphicsContext currentContext] restoreGraphicsState];
    }
}


@end