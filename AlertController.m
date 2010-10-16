@implementation alertController

//@synthesize eventArray;

- (void)newAlert:(NSString *)title ofType:(NSString *)alertType withBundle:(NSString *)bundle
{
    //Add the alert to our internal array for tracking:
    alertDataController *data = [[alertDataController alloc] init];
    [data initWithText:title bundleID:bundle andType:alertType];

    [eventArray addObject:data];
    [self saveArray];

    NSLog(@"%@", eventArray);
    //Create alertDisplayController object, and populate members
    
    alertDisplayController *display = [[alertDisplayController alloc] init];
    [display intWithText:title type:alertType andBundle:bundle];

    //Add alertDisplayController to alertWindow

    display.view.origin = CGPointMake(0, alertHeight * ([eventArray count] - 1));

    [self updateSize];
    NSLog(@"size updated");
    [alertWindow addSubview: display.view];
}

- (void)removeAlertFromArray:(alertDataController *)alert
{
    for(unsigned int i = 0; i < [eventArray count]; i++)
    {
        if([[[eventArray objectAtIndex:i] alertText] isEqual:alert.alertText])
        {
            //if([[[eventArray objectAtIndex:i] alertType] isEqual:alert.alertType])
            //{
                if([[[eventArray objectAtIndex:i] bundleIdentifier] isEqual:alert.bundleIdentifier])
                {
                    [eventArray removeObjectAtIndex:i];
                }
            //}
        }
    }

    [self saveArray];
}

- (void)saveArray
{
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/MobileNotifier/notifications.plist"])
    {
        //Aha! Good, let's save the array
        [NSKeyedArchiver archiveRootObject:eventArray toFile:@"/var/mobile/Library/MobileNotifier/notifications.plist"];
    }
    else
    {
        //Something terrible has happened!
        [NSKeyedArchiver archiveRootObject:eventArray toFile:@"/var/mobile/Library/MobileNotifier/notifications.plist"];
    }
}

- (void)loadArray 
{
    NSLog(@"Allocating eventArray");

    //eventArray = [[NSMutableArray arrayWithContentsOfFile:@"/var/mobile/MobileNotifier/notifications.plist"] retain];
    eventArray = [[NSKeyedUnarchiver unarchiveObjectWithFile:@"/var/mobile/Library/MobileNotifier/notifications.plist"] retain];
    if(!eventArray)
    {
        //First time user! Let's present them with some information.
        NSLog(@"Event array file doesn't exist!"); 

        //Create the directory!
        [[NSFileManager defaultManager] createDirectoryAtPath:@"/var/mobile/Library/MobileNotifier/" withIntermediateDirectories:NO attributes:nil error:NULL];

        eventArray = [[NSMutableArray alloc] init];

        //Now, we should create the array.
        [NSKeyedArchiver archiveRootObject:eventArray toFile:@"/var/mobile/Library/MobileNotifier/notifications.plist"];

    } 
}

- (void)updateSize
{
    int newHeight = (CGFloat)(alertHeight * [eventArray count]);

    alertWindow.frame = CGRectMake(0,20,320, newHeight);
}



//libactivator methods:
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
    NSLog(@"We received an LAEvent!");
}
- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event
{
    NSLog(@"We received an LAEvent abort!");
}
@end
