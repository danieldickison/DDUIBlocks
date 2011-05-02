//
//  DDBlockBarButtonItem.m
//  DDUIBlockDemo
//
//  Created by Daniel Dickison on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DDBlockBarButtonItem.h"


@implementation DDBlockBarButtonItem

- (void)dealloc
{
    [handler release];
    [super dealloc];
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(void (^)())handler_
{
    if ((self = [super initWithBarButtonSystemItem:systemItem target:self action:@selector(callHandler)]))
    {
        handler = [handler_ copy];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(void (^)())handler_
{
    if ((self = [super initWithTitle:title style:style target:self action:@selector(callHandler)]))
    {
        handler = [handler_ copy];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(void (^)())handler_
{
    if ((self = [super initWithImage:image style:style target:self action:@selector(callHandler)]))
    {
        handler = [handler_ copy];
    }
    return self;
}

+ (DDBlockBarButtonItem *)barButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(void(^)())handler_
{
    return [[[self alloc] initWithBarButtonSystemItem:systemItem handler:handler_] autorelease];
}

+ (DDBlockBarButtonItem *)barButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(void(^)())handler_
{
    return [[[self alloc] initWithTitle:title style:style handler:handler_] autorelease];
}

+ (DDBlockBarButtonItem *)barButtonItemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(void(^)())handler_
{
    return [[[self alloc] initWithImage:image style:style handler:handler_] autorelease];
}

- (void)callHandler
{
    // Should I [[self retain] autorelease]?
    if (handler) handler();
}

- (void)setTarget:(id)target
{
    NSAssert(target == self, @"Target and action of DDBlockBarButtonItem cannot be changed.");
    [super setTarget:target];
}
- (void)setAction:(SEL)action
{
    NSAssert(action == @selector(callHandler), @"Target and action of DDBlockBarButtonItem cannot be changed.");
    [super setAction:action];
}

@end
