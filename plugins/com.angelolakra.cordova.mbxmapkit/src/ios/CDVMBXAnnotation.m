#import "CDVMBXAnnotation.h"

@implementation CDVMBXAnnotation
@synthesize identifier = _identifier;
@synthesize type = _type;
@synthesize coordinate = _coordinate;
@synthesize title = _title;

- (void)setType:(CDVMBXAnnotationType *)type
{
  _type = type;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
  _coordinate = coordinate;
}

- (void)setTitle:(NSString *)title
{
  _title = title;
}

- (void)setIdentifier:(NSString *)identifier
{
  _identifier = identifier;
}

@end
