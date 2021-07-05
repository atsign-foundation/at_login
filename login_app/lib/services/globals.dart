library at_persona.at_globals;

import 'package:at_settings/services/at_services.dart';

/// The root environment to which @persona points to. By default it points to [Staging].
RootEnvironment rootEnvironment = RootEnvironment.Staging;

///determines whether to load the shared data for an [atsign].
bool loadProfileIndex = false;

bool loadFollowers = false;

FollowType followType = FollowType.notification;
