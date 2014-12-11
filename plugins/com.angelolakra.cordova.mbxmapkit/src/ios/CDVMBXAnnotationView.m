#import "CDVMBXAnnotationView.h"

@implementation CDVMBXAnnotationView
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

  if (self != nil)
  {
    self.canShowCallout = YES;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}
@end
