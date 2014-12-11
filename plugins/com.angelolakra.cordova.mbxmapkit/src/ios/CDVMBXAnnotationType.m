#import "CDVMBXAnnotationType.h"

@implementation CDVMBXAnnotationType
@synthesize name = _name;
@synthesize imageUri = _imageUri;
@synthesize image = _image;
@synthesize isRemote = _isRemote;
@synthesize directory = _directory;

- (void)setName:(NSString *)name
{
  _name = name;
}

- (void)setImageUri:(NSString *)imageUri
{
  _imageUri = imageUri;
}

- (void)setIsRemote:(BOOL)isRemote
{
  _isRemote = isRemote;
}

- (void)setDirectory:(NSString *)directory
{
  _directory = directory;
}

- (void)loadImage
{
  if (_image) { return; }

  NSURL *url;
  if (_isRemote) {
    url = [self remoteImageUrl];
  } else {
    url = [self localImageUrl];
  }

  NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url];

  [NSURLConnection sendAsynchronousRequest:imageRequest
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
      if (data) {
        _image = [UIImage imageWithData:data scale:4.0];
      }
    }];
}

-(NSURL *)remoteImageUrl
{
  return [NSURL URLWithString:_imageUri];
}

-(NSURL *)localImageUrl
{
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:_imageUri ofType:@"" inDirectory:_directory];
  return [NSURL fileURLWithPath:imagePath];
}

@end
