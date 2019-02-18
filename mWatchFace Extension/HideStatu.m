//
//  HideStatu.m
//  SpriteKitWatchTest Extension
//
//  Created by 李弘辰 on 2019/2/10.
//  Copyright © 2019 李弘辰. All rights reserved.
//

#import "HideStatu.h"

@interface NSObject (fs_override)
+(id)sharedApplication;
-(id)keyWindow;
-(id)rootViewController;
-(NSArray *)viewControllers;
-(id)view;
-(NSArray *)subviews;
-(id)timeLabel;
-(id)layer;
@end

@implementation HideStatu

+ (void) hide:(WKInterfaceController<WKCrownDelegate> *) controller
{
    /* Hack to make the digital time overlay disappear */
    
    NSArray *views = [[[[[[[NSClassFromString(@"UIApplication") sharedApplication] keyWindow] rootViewController] viewControllers] firstObject] view] subviews];
    
    for (NSObject *view in views)
    {
        if ([view isKindOfClass:NSClassFromString(@"SPFullScreenView")])
        [[[view timeLabel] layer] setOpacity:0];
    }
    
    controller.crownSequencer.delegate = controller;
    [controller.crownSequencer focus];
}

@end
