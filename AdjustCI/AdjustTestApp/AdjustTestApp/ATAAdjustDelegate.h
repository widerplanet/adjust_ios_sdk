//
//  ATAAdjustDelegate.h
//  AdjustTestApp
//
//  Created by Pedro on 26.10.17.
//  Copyright © 2017 adjust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Adjust.h"
#import "ATLTestLibrary.h"

@interface ATAAdjustDelegate : NSObject<AdjustDelegate>

- (id)initWithTestLibrary:(ATLTestLibrary *)testLibrary;

- (void)swizzleCallbackMethod:(SEL)originalSelector
             swizzledSelector:(SEL)swizzledSelector;
@end
