//
//  TCEditorVC.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TCEditorVCTypeAdd = 0,
    TCEditorVCTypeEdit

} TCEditorVCType;

@interface TCEditorVC : UIViewController

@property (nonatomic, strong) TCDairy *editDairy;
@property (nonatomic, assign) TCEditorVCType type;

@end
