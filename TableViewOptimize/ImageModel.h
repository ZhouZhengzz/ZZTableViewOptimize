//
//  ImageModel.h
//  TableViewOptimize
//
//  Created by zhouzheng on 2017/12/5.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isLoad;

@end
