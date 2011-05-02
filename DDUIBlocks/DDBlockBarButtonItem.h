//
//  DDBlockBarButtonItem.h
//  DDUIBlockDemo
//
//  Created by Daniel Dickison on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DDBlockBarButtonItem : UIBarButtonItem
{
@private
    void (^handler)();
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(void(^)())handler_;
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(void(^)())handler_;
- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(void(^)())handler_;
+ (DDBlockBarButtonItem *)barButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(void(^)())handler_;
+ (DDBlockBarButtonItem *)barButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(void(^)())handler_;
+ (DDBlockBarButtonItem *)barButtonItemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(void(^)())handler_;

// DDBlockBarButtonItem sets itself as the target, so these methods should never be called from application code.
- (void)setTarget:(id)target;
- (void)setAction:(SEL)action;

@end
