import 'package:flutter/widgets.dart';
import 'package:kecs/dashboard/dashboard.dart';
import 'package:kecs/mycustomers/mycustomers.dart';
import 'package:kecs/profile/profile.dart';
import 'package:kecs/login.dart';
import 'package:kecs/tracking/tracking.dart';

final Map<String, WidgetBuilder> routes = {
  Dashboard.routeName: (context) => const Dashboard(),
  Login.routeName: (context) => const Login(
        title: '',
      ),
  Profile.routeName: (context) => const Profile(title: ''),
  MyCustomers.routeName: (context) => const MyCustomers(title: ''),
  Tracking.routeName: (context) => const Tracking(title: ''),
};
