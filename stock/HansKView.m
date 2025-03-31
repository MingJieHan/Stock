//
//  HansKView.m
//  stack
//
//  Created by jia yu on 2023/10/14.
//

#import "HansKView.h"
#import "HansKItemView.h"

@interface HansKView(){
    NSMutableArray <HansKItemView *>*kViews;
    NSMutableArray <UILabel *>*labels;
    float maximum;
    float minimum;
}

@end

@implementation HansKView
@synthesize kItems;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        kViews = [[NSMutableArray alloc] init];
        
        labels = [[NSMutableArray alloc] init];
        for (int i=0;i<5;i++){
            float y = i * frame.size.height/4.f;
            if (4 == i){
                y -= 16.f;
            }
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(3.f, y, 100.f, 14.f)];
            l.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10.f];
            l.textColor = [UIColor blackColor];
            l.textAlignment = NSTextAlignmentLeft;
            [self addSubview:l];
            [labels addObject:l];
        }
    }
    return self;
}

-(void)setKItems:(NSArray<HansKObject *> *)_kItems{
    kItems = _kItems;
    for (HansKItemView *v in kViews){
        [v removeFromSuperview];
    }
    [kViews removeAllObjects];
    if (nil == kItems){
        for (UILabel *l in labels){
            l.text = @"";
        }
        return;
    }
    
    float kWidth = self.frame.size.width/kItems.count;
    
    maximum = 0.f;
    minimum = MAXFLOAT;
    for (HansKObject *o in kItems){
        if (maximum < o.high){
            maximum = o.high;
        }
        if (minimum > o.low){
            minimum = o.low;
        }
    }
    
    float currentX = 0.f;
    for (HansKObject *o in kItems){
        HansKItemView *v = [[HansKItemView alloc] initWithFrame:CGRectMake(currentX, 0.f, kWidth, self.frame.size.height)];
        v.maximumVolume = maximum;
        v.minimumVolume = minimum;
        currentX += kWidth;
        v.object = o;
        [self addSubview:v];
        [kViews addObject:v];
    }
    
    [labels objectAtIndex:0].text = [NSString stringWithFormat:@"%.2f", maximum];
    [labels objectAtIndex:1].text = [NSString stringWithFormat:@"%.2f", (maximum-minimum)*0.75f + minimum];
    [labels objectAtIndex:2].text = [NSString stringWithFormat:@"%.2f", (maximum-minimum)*0.5f + minimum];
    [labels objectAtIndex:3].text = [NSString stringWithFormat:@"%.2f", (maximum-minimum)*0.25f + minimum];
    [labels objectAtIndex:4].text = [NSString stringWithFormat:@"%.2f", minimum];
    for (UILabel *l in labels){
        [self bringSubviewToFront:l];
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    float width = 0.6f;
    UIColor *lineColor = [UIColor lightGrayColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, width);
    NSArray *linesY = @[[NSNumber numberWithFloat:width/2.f],
                        [NSNumber numberWithFloat:self.frame.size.height*0.25],
                        [NSNumber numberWithFloat:self.frame.size.height * 0.5],
                        [NSNumber numberWithFloat:self.frame.size.height*0.75],
                        [NSNumber numberWithFloat:self.frame.size.height-width/2.f]];
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSNumber *y in linesY){
        [path moveToPoint:CGPointMake(0, [y floatValue])];
        [path addLineToPoint:CGPointMake(self.frame.size.width, [y floatValue])];
    }
    CGContextAddPath(context, path.CGPath);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    float stepX = self.frame.size.width/kItems.count;
    float volumePerPix = (maximum - minimum)/self.frame.size.height;
    UIColor *average5Color = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.f];
    NSMutableArray *average5Array = [[NSMutableArray alloc] init];
    for (HansKObject *o in kItems){
        [average5Array addObject:[NSNumber numberWithFloat:o.average5]];
    }
    [self drawAverageLine:average5Array withColor:average5Color withPerPix:volumePerPix withStep:stepX];
    
    UIColor *average10Color = [UIColor colorWithRed:0.53 green:0.f blue:1.f alpha:1.f];
    NSMutableArray *average10Array = [[NSMutableArray alloc] init];
    for (HansKObject *o in kItems){
        [average10Array addObject:[NSNumber numberWithFloat:o.average10]];
    }
    [self drawAverageLine:average10Array withColor:average10Color withPerPix:volumePerPix withStep:stepX];
    
    UIColor *average20Color = [UIColor colorWithRed:0.99 green:0.65 blue:0.07 alpha:1.f];
    NSMutableArray *average20Array = [[NSMutableArray alloc] init];
    for (HansKObject *o in kItems){
        [average20Array addObject:[NSNumber numberWithFloat:o.average20]];
    }
    [self drawAverageLine:average20Array withColor:average20Color withPerPix:volumePerPix withStep:stepX];

    UIColor *average30Color = [UIColor colorWithRed:0.05 green:0.f blue:0.56 alpha:1.f];
    NSMutableArray *average30Array = [[NSMutableArray alloc] init];
    for (HansKObject *o in kItems){
        [average30Array addObject:[NSNumber numberWithFloat:o.average30]];
    }
    [self drawAverageLine:average30Array withColor:average30Color withPerPix:volumePerPix withStep:stepX];
    return;
}

-(void)drawAverageLine:(NSArray *)array withColor:(UIColor *)color withPerPix:(float)volumePerPix withStep:(float)stepX{
    float currentX = 0.f;
    float width = 0.6f;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(context, width);
    UIBezierPath *path = [UIBezierPath bezierPath];
    BOOL penDown = NO;
    for (NSNumber *n in array){
        float y = (maximum - [n floatValue])/volumePerPix;
        if (penDown){
            [path addLineToPoint:CGPointMake(currentX, y)];
        }else{
            [path moveToPoint:CGPointMake(currentX, y)];
            penDown = YES;
        }
        currentX += stepX;
    }
    [path moveToPoint:CGPointMake(-1.f, -1.f)];
    [path closePath];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}
@end
