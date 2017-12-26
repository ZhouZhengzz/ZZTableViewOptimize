//
//  TableViewCell.h
//  TableViewOptimize
//
//  Created by zhouzheng on 2017/12/5.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"

@class TableViewCell;
@protocol CellDelegate <NSObject>
- (void)textFieldDidBeginEditing:(TableViewCell *)cell;
@end

@interface TableViewCell : UITableViewCell

@property (nonatomic, weak) id<CellDelegate> delegate;
@property (nonatomic, strong) ImageModel *model;

@end
