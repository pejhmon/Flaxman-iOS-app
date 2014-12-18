#import "CDVMBXMapKit.h"


@interface CDVMBXMapKit () { }

@property (nonatomic) MBXRasterTileOverlay *rasterOverlay;
@property (nonatomic) NSString *onlineMapId;
@property (nonatomic) int annotationIdCount;
@property (nonatomic) NSMutableDictionary *annotations;
@property (nonatomic) NSMutableDictionary *annotationTypes;

@end

@implementation CDVMBXMapKit

- (void)pluginInitialize
{
  self.annotations     = [NSMutableDictionary new];
  self.annotationTypes = [NSMutableDictionary new];
  self.annotationIdCount = 0;
}

- (void)create:(CDVInvokedUrlCommand*)command
{
  if (self.mapView != nil) { return; }

  CGRect frame = CGRectMake(self.webView.bounds.origin.x, self.webView.bounds.origin.y, self.webView.bounds.size.width, self.webView.bounds.size.height);
  self.childView = [[UIView alloc] initWithFrame:frame];

  self.mapView                       = [[MKMapView alloc] initWithFrame:self.childView.bounds];
  self.mapView.delegate              = self;
  self.mapView.mapType               = MKMapTypeStandard;
  self.mapView.zoomEnabled           = YES;
  self.mapView.rotateEnabled         = NO;
  self.mapView.scrollEnabled         = YES;
  self.mapView.pitchEnabled          = NO;
  self.mapView.showsPointsOfInterest = NO;
  self.mapView.autoresizingMask      = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  self.childView.autoresizingMask    = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.childView.contentMode         = UIViewContentModeRedraw;

  [self.childView addSubview:self.mapView];
}

- (void)destroy:(CDVInvokedUrlCommand*)command
{
  [self.mapView removeAnnotations:[self.annotations allValues]];
  [self.annotations removeAllObjects];
  [self.mapView removeOverlays:self.mapView.overlays];
  [self.annotationTypes removeAllObjects];

  self.mapView = nil;

  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Destroyed the map."];
}

- (void)show:(CDVInvokedUrlCommand*)command
{
  [[[ self viewController ] view ] addSubview:self.childView];
}

- (void)hide:(CDVInvokedUrlCommand*)command
{
  [self.childView removeFromSuperview];
}

- (void)setMapId:(CDVInvokedUrlCommand*)command
{
  _onlineMapId = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];
  if ([_onlineMapId length] != 0) { [self addOnlineMapLayer:_onlineMapId]; }
}

- (void)getMapId:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:_onlineMapId];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getSize:(CDVInvokedUrlCommand*)command
{
  NSDictionary* params = @{ @"width" : [NSNumber numberWithFloat:self.childView.frame.size.width],
                            @"height" : [NSNumber numberWithFloat: self.childView.frame.size.height] };

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setSize:(CDVInvokedUrlCommand*)command
{
  NSInteger width  = [[command.arguments objectAtIndex:0] floatValue];
  NSInteger height = [[command.arguments objectAtIndex:1] floatValue];

  CGRect frame = CGRectMake(self.webView.bounds.origin.x, self.webView.bounds.origin.y, width, height);

  [UIView animateWithDuration:0.15 animations:^{
      self.childView.frame = frame;
    }];
}

- (void)getCenter:(CDVInvokedUrlCommand*)command
{
  NSDictionary* params = @{ @"x" : [NSNumber numberWithFloat: self.childView.center.x],
                            @"y" : [NSNumber numberWithFloat: self.childView.center.y] };

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setCenter:(CDVInvokedUrlCommand*)command
{
  NSInteger x = [[command.arguments objectAtIndex:0] floatValue];
  NSInteger y = [[command.arguments objectAtIndex:1] floatValue];

  self.childView.center = CGPointMake(x, y);
}

- (void)registerAnnotationType:(CDVInvokedUrlCommand*)command
{
  NSString* name      = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];
  NSString* uri       = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:1]];
  BOOL isRemote       = [[command.arguments objectAtIndex:2] boolValue];
  NSString* directory = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:3]];

  CDVMBXAnnotationType* type = [CDVMBXAnnotationType new];
  [type setName:name];
  [type setImageUri:uri];
  [type setIsRemote:isRemote];
  [type setDirectory:directory];

  [type loadImage];

  [self.annotationTypes setObject:type forKey:name];

  NSDictionary* params = @{@"name":name, @"uri":uri};
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addAnnotation:(CDVInvokedUrlCommand*)command
{
  NSString* title = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];

  CLLocationDegrees latitude  = [[command.arguments objectAtIndex:1] doubleValue];
  CLLocationDegrees longitude = [[command.arguments objectAtIndex:2] doubleValue];
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);

  NSString* type  = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:3]];
  CDVMBXAnnotationType* annotationType = [self.annotationTypes objectForKey:type];

  NSString* identifier = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:4]];

  CDVMBXAnnotation* annotation = [CDVMBXAnnotation new];

  if (annotationType) {
    [annotation setType:annotationType];
  }

  [annotation setIdentifier:identifier];
  [annotation setTitle:title];
  [annotation setCoordinate:coordinate];

  [self.mapView addAnnotation:annotation];
  [self.annotations setObject:annotation forKey:identifier];

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:identifier];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)removeAnnotation:(CDVInvokedUrlCommand*)command
{
  NSString* identifier = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];
  [self.mapView removeAnnotation:[self.annotations objectForKey:identifier]];
  [self.annotations removeObjectForKey:identifier];

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Removed annotation."];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)removeAllAnnotations:(CDVInvokedUrlCommand*)command
{
  [self.mapView removeAnnotations:[self.annotations allValues]];
  [self.annotations removeAllObjects];

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Removed all annotations."];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setCenterCoordinate:(CDVInvokedUrlCommand*)command
{
  CLLocationDegrees latitude  = [[command.arguments objectAtIndex:0] doubleValue];
  CLLocationDegrees longitude = [[command.arguments objectAtIndex:1] doubleValue];
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);

  [self.mapView setCenterCoordinate:coordinate];

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Centered around coordinate."];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getRegion:(CDVInvokedUrlCommand*)command
{
  MKCoordinateRegion region = [self.mapView regionThatFits:self.mapView.region];

  CLLocationDegrees latitude  = region.center.latitude;
  CLLocationDegrees longitude = region.center.longitude;
  CLLocationDegrees latitudinal  = region.span.latitudeDelta;
  CLLocationDegrees longitudinal = region.span.longitudeDelta;

  NSDictionary *params = @{ @"center": @{ @"latitude": [NSNumber numberWithDouble:latitude], @"longitude": [NSNumber numberWithDouble:longitude]},
                            @"delta": @{ @"latitudinalDelta": [NSNumber numberWithDouble:latitudinal], @"longitudinalDelta": [NSNumber numberWithDouble:longitudinal]} };

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setRegion:(CDVInvokedUrlCommand*)command
{
  CLLocationDegrees latitude  = [[command.arguments objectAtIndex:0] doubleValue];
  CLLocationDegrees longitude = [[command.arguments objectAtIndex:1] doubleValue];
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);

  CLLocationDegrees latitudeDelta  = [[command.arguments objectAtIndex:2] doubleValue];
  CLLocationDegrees longitudeDelta = [[command.arguments objectAtIndex:3] doubleValue];

  MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
  MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);

  [self.mapView setRegion:region animated:YES];

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Resized map around coordinate."];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)selectedAnnotations:(CDVInvokedUrlCommand*)command
{
  NSArray *annotations = [self.mapView selectedAnnotations];
  __block NSMutableArray *annotationsAsJson = [NSMutableArray new];

  [annotations enumerateObjectsUsingBlock:^(id <MKAnnotation> obj, NSUInteger idx, BOOL *stop) {
      [annotationsAsJson addObject:[self getAnnotationId:obj]];
    }];

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:annotationsAsJson];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Helper Methods

- (void)addOnlineMapLayer:(NSString *)mapId
{
  // remove old overlay if it exists
  if (_rasterOverlay != nil) {
    [self.mapView removeOverlay:_rasterOverlay];
  }

  // add new overlay
  _rasterOverlay = [[MBXRasterTileOverlay alloc] initWithMapID:mapId];
  _rasterOverlay.delegate = self;
  [self.mapView addOverlay:_rasterOverlay];
}

- (NSString *)getAnnotationId:(id <MKAnnotation>)annotation
{
  return [NSString stringWithFormat:@"%@|%@",
                   [[NSNumber numberWithDouble: annotation.coordinate.latitude] stringValue],
                   [[NSNumber numberWithDouble: annotation.coordinate.longitude] stringValue]];
}

#pragma mark - MKMapViewDelegate protocol implementation

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapRegionWillChange']);"];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapRegionChanged']);"];
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapWillStartLoading']);"];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapFinishedLoading']);"];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
  NSString *command = [NSString stringWithFormat:@"var e=mbxmapkit.events['mapFailedToLoad'];e.detail.error='%@';document.dispatchEvent(e);", [error localizedDescription]];
  [self.commandDelegate evalJs:command];
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapWillStartRendering']);"];
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
  NSString *isRendered = (fullyRendered) ? @"true" : @"false";
  NSString *command = [NSString stringWithFormat:@"var e=mbxmapkit.events['mapFinishedRendering'];e.detail.fullyRendered=%@;document.dispatchEvent(e);", isRendered];
  [self.commandDelegate evalJs:command];
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapWillStartLocatingUser']);"];
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapStoppedLocatingUser']);"];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterLongStyle];
  [dateFormatter setTimeStyle:NSDateFormatterLongStyle];

  NSString *dateString = [dateFormatter stringFromDate:userLocation.location.timestamp];
  NSString *options = [NSString stringWithFormat:@"{ latitude: %f, longitude: %f, altitude: %f, timestamp: '%@' }",
                                userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude, userLocation.location.altitude, dateString];

  NSString *command = [NSString stringWithFormat:@"var e=mbxmapkit.events['mapUpdatedUserLocation'];e.detail.location=%@;document.dispatchEvent(e);", options];
  [self.commandDelegate evalJs:command];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
  NSString *command = [NSString stringWithFormat:@"var e=mbxmapkit.events['mapFailedToLocateUser'];e.detail.error='%@';document.dispatchEvent(e);", [error localizedDescription]];
  [self.commandDelegate evalJs:command];
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapChangedUserTrackingMode']);"];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  NSString *command = [NSString stringWithFormat:@"var e=mbxmapkit.events['mapRequestedAnnotation'];e.detail.annotationId='%@';document.dispatchEvent(e);", [self getAnnotationId:annotation]];
  [self.commandDelegate evalJs:command];

  if ([annotation isKindOfClass:[MBXPointAnnotation class]]) {
    static NSString *MBXSimpleStyleReuseIdentifier = @"MBXSimpleStyleReuseIdentifier";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXSimpleStyleReuseIdentifier];

    if (!view) {
      view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MBXSimpleStyleReuseIdentifier];
    }

    view.image = ((MBXPointAnnotation *)annotation).image;
    view.canShowCallout = YES;
    return view;

  } else if ([annotation isKindOfClass:[CDVMBXAnnotation class]] && ((CDVMBXAnnotation *)annotation).type) {
    CDVMBXAnnotationType *annotationType = ((CDVMBXAnnotation *)annotation).type;
    CDVMBXAnnotationView *view = [[CDVMBXAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationType.name];
    view.image = annotationType.image;
    return view;
  } else {
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    return view;
  }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapAddedAnnotations']);"];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapAnnotationCalloutTapped']);"];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapChangedAnnotationDragState']);"];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
  NSString *command = [NSString stringWithFormat:@"var e=mbxmapkit.events['mapAnnotationSelected'];e.detail.annotationId='%@';document.dispatchEvent(e);", [self getAnnotationId:view.annotation]];
  [self.commandDelegate evalJs:command];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
  NSString *command = [NSString stringWithFormat:@"var e=mbxmapkit.events['mapAnnotationDeselected'];e.detail.annotationId='%@';document.dispatchEvent(e);", [self getAnnotationId:view.annotation]];
  [self.commandDelegate evalJs:command];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapOverlayRequested']);"];

  // This is boilerplate code to connect tile overlay layers with suitable renderers
  //
  if ([overlay isKindOfClass:[MBXRasterTileOverlay class]]) {
    MKTileOverlayRenderer *renderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    return renderer;
  }

  return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers
{
  [self.commandDelegate evalJs:@"document.dispatchEvent(mbxmapkit.events['mapAddedOverlays']);"];
}



#pragma mark - MBXRasterTileOverlayDelegate implementation

- (void)tileOverlay:(MBXRasterTileOverlay *)overlay didLoadMetadata:(NSDictionary *)metadata withError:(NSError *)error
{
  // This delegate callback is for centering the map once the map metadata has been loaded
  //
  if (error) {
    NSLog(@"Failed to load metadata for map ID %@ - (%@)", overlay.mapID, error?error:@"");
  } else {
    [self.mapView mbx_setCenterCoordinate:overlay.center zoomLevel:overlay.centerZoom animated:NO];
  }
}


- (void)tileOverlay:(MBXRasterTileOverlay *)overlay didLoadMarkers:(NSArray *)markers withError:(NSError *)error
{
  // This delegate callback is for adding map markers to an MKMapView once all the markers for the tile overlay have loaded
  //
  if (error) {
    NSLog(@"Failed to load markers for map ID %@ - (%@)", overlay.mapID, error?error:@"");
  }
  else {
    [self.mapView addAnnotations:markers];
  }
}

- (void)tileOverlayDidFinishLoadingMetadataAndMarkers:(MBXRasterTileOverlay *)overlay
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
