import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/provider/async_value.dart';
import 'package:week_3_blabla_project/provider/ride_pref_provider.dart';
import 'package:week_3_blabla_project/ui/widgets/errors/bla_error_screen.dart';

import '../../../model/ride/ride_pref.dart';

import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  // Move onRidePrefSelected outside the build method
  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference
    context.read<RidesPreferencesProvider>().setCurrentPreference(newPreference);
    
    // 2 - Navigate to the rides screen (with a bottom to top animation)
    await Navigator.of(context).push(
      AnimationUtils.createBottomToTopRoute(RidesScreen()),
    );
    
    // 3 - State management will handle the updated state (already done by Provider)
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RidesPreferencesProvider>(
      builder: (context, provider, child) {
        if(provider.pastPreferences.state == AsyncValueState.loading){
          return BlaError(message: 'Loading');
        }else if(provider.pastPreferences.state == AsyncValueState.error){
          return BlaError(message: 'No connection. Try later message');
        }
        return Stack(
          children: [
            // Background Image
            BlaBackground(),

            // Foreground content
            Column(
              children: [
                SizedBox(height: BlaSpacings.m),
                Text(
                  "Your pick of rides at low price",
                  style: BlaTextStyles.heading.copyWith(color: Colors.white),
                ),
                SizedBox(height: 100),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Display the Form to input the ride preferences
                      RidePrefForm(
                        initialPreference: provider.currentPreference,
                        onSubmit: (preference) => onRidePrefSelected(context, preference),
                      ),
                      SizedBox(height: BlaSpacings.m),

                      // Optionally display a list of past preferences
                      SizedBox(
                        height: 200, // Set a fixed height
                        child: ListView.builder(
                          shrinkWrap: true, // Fix ListView height issue
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: provider.preferencesHistory.length,
                          itemBuilder: (ctx, index) => RidePrefHistoryTile(
                            ridePref: provider.preferencesHistory[index],
                            onPressed: () => onRidePrefSelected(
                              context,
                              provider.preferencesHistory[index],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, 
      ),
    );
  }
}
