//
//  VCCell.m
//  CommonTest
//
//  Created by zzyong on 2021/3/22.
//

#import "VCCell.h"
#import "VCModel.h"

@implementation VCCell

- (void)setModel:(VCModel *)model {
    _model = model;
    
    self.textLabel.text = model.title;
    self.textLabel.numberOfLines = 2;
}

@end
