import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_drawer.dart';

import '../widgets/album_section.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                child: const HomeHeader(userName: 'Mohanned'),
              ),

              SizedBox(height: 28.h),

              /// Search
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: HomeSearchBar(onChanged: (value) {}),
              ),

              SizedBox(height: 32.h),

              /// My Albums
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: AlbumSection(title: 'My Albums', onSeeAll: () {}),
              ),

              SizedBox(height: 34.h),

              /// Invited Albums
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: AlbumSection(title: 'Invited Albums', onSeeAll: () {}),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
