import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/core/theme/app-colors.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({
    super.key,
    this.onChanged,
    this.onSearchPressed,
    this.controller,
    this.autofocus = false,
    this.readOnly = false,
  });

  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchPressed;

  final TextEditingController? controller;

  final bool autofocus;
  final bool readOnly;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_refresh);
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,

      onChanged: widget.onChanged,

      onTap: () {
        if (widget.readOnly) {
          widget.onSearchPressed?.call();
        }
      },

      decoration: InputDecoration(
        hintText: "Search albums...",

        prefixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: widget.onSearchPressed,
        ),

        suffixIcon:
            widget.controller != null && widget.controller!.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.controller!.clear();
                  widget.onChanged?.call("");
                },
              )
            : null,

        filled: true,
        fillColor: AppColors.surface,

        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
