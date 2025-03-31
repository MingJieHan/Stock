//
//  HansKView.m
//  stack
//
//  Created by jia yu on 2023/10/13.
//

#import "HansKItemView.h"
@interface HansKItemView(){
    UILabel *actionLabel;
}
@end

@implementation HansKItemView
@synthesize object;
@synthesize maximumVolume,minimumVolume;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, frame.size.height-40.f, frame.size.width, 40.f)];
        actionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        actionLabel.backgroundColor = [UIColor clearColor];
        actionLabel.textAlignment = NSTextAlignmentCenter;
        actionLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10.f];
        [self addSubview:actionLabel];
    }
    return self;
}

-(void)setObject:(HansKObject *)_object{
    object = _object;
    if (object.type == KObjectActionType_Saled){
        actionLabel.text = @"S";
        actionLabel.backgroundColor = [UIColor redColor];
    }else if (object.type == KObjectActionType_Buy){
        actionLabel.text = @"B";
        actionLabel.backgroundColor = [UIColor greenColor];
    }else{
        actionLabel.text = @"";
        if (object.stock > 0){
            //持有
            actionLabel.backgroundColor = [UIColor colorWithRed:1.f green:0.65 blue:0.f alpha:0.5];
        }else{
            //空仓
            actionLabel.backgroundColor = [UIColor clearColor];
        }
    }
    [self setNeedsDisplay];
    return;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@", object);
    return;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    BOOL down = NO;
    UIColor *lineColor = [UIColor whiteColor];
    if (object.open > object.close){
        down = YES;
        lineColor = [UIColor colorWithRed:0.04 green:0.34 blue:0.f alpha:1.f];
    }else{
        down = NO;
        lineColor = [UIColor colorWithRed:0.73 green:0.f blue:0.01f alpha:1.f];
    }
  
    float volumePerPix = (maximumVolume - minimumVolume)/self.frame.size.height;
    float top1 = (maximumVolume - object.high)/volumePerPix;
    float top4 = (maximumVolume - object.low)/volumePerPix;
    float top3,top2;
    if (down){
        top2 = (maximumVolume - object.open)/volumePerPix;
        top3 = (maximumVolume - object.close)/volumePerPix;
    }else{
        top2 = (maximumVolume - object.close)/volumePerPix;
        top3 = (maximumVolume - object.open)/volumePerPix;
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    if (down){
        CGContextSetFillColorWithColor(context, lineColor.CGColor);
    }else{
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    }
    CGContextSetLineWidth(context, 0.6f);
    float center =  self.frame.size.width * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(1.5f, top2, self.frame.size.width-3.f, top3-top2)];
    [path moveToPoint:CGPointMake(center, top1)];
    [path addLineToPoint:CGPointMake(center, top2)];
    
    [path moveToPoint:CGPointMake(center, top3)];
    [path addLineToPoint:CGPointMake(center, top4)];
    CGContextAddPath(context, path.CGPath);
    CGContextDrawPath(context, kCGPathFillStroke);
    return;
}
@end
