import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_vendor_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final disabledVendorIdsBtnFinder = find.byKey(Key("getDisabledVendorIds"));
  final enabledVendorIdsBtnFinder = find.byKey(Key("getEnabledVendorIds"));
  final requiredVendorIdsBtnFinder = find.byKey(Key("getRequiredVendorIds"));
  final disabledVendorsBtnFinder = find.byKey(Key("getDisabledVendors"));
  final enabledVendorsBtnFinder = find.byKey(Key("getEnabledVendors"));
  final requiredVendorsBtnFinder = find.byKey(Key("getRequiredVendors"));
  final getVendorBtnFinder = find.byKey(Key("getVendor"));
  final listKey = Key("components_list");

  // Native message strings.
  const emptyDisabledVendorMessage = "Native message: Disabled Vendor list is empty.";
  const emptyEnabledVendorMessage = "Native message: Enabled Vendor list is empty.";
  const suffixVendorMessage = "1, 10, 100, 1000, 1001, 1002, 1003, 1004, 1006, 1007, 101, 1010, 1011, 1012, 1015, 1016, 102, 104, 108, 109, 11, 110, "
      "111, 114, 115, 119, 12, 120, 122, 124, 126, 127, 128, 129, 13, 130, 131, 132, 133, 134, 136, 137, 138, 139, 14, 140, 141, 142, 143, 144, 145, 147, "
      "148, 149, 15, 150, 151, 152, 153, 154, 155, 157, 158, 159, 16, 160, 161, 162, 163, 164, 165, 167, 168, 170, 173, 174, 177, 178, 179, 18, 183, "
      "184, 185, 190, 192, 193, 194, 195, 196, 198, 199, 2, 20, 200, 202, 203, 205, 206, 208, 209, 21, 210, 211, 212, 213, 215, 216, 217, 218, 22, 223, "
      "224, 226, 227, 228, 23, 230, 231, 234, 235, 236, 237, 238, 239, 24, 240, 241, 242, 243, 244, 246, 248, 249, 25, 250, 251, 252, 253, 254, 255, "
      "256, 259, 26, 261, 262, 263, 264, 265, 266, 27, 270, 272, 273, 274, 275, 276, 277, 28, 281, 282, 284, 285, 289, 29, 290, 293, 294, 295, 297, 298, "
      "299, 30, 301, 302, 303, 304, 308, 31, 310, 311, 312, 314, 315, 316, 317, 318, 319, 32, 321, 323, 325, 328, 329, 33, 331, 333, 335, 336, 337, 34, "
      "343, 345, 347, 349, 350, 351, 354, 358, 359, 36, 360, 361, 368, 37, 371, 373, 374, 375, 377, 378, 380, 381, 382, 385, 387, 388, 39, 394, 397, 4, "
      "40, 402, 408, 409, 41, 410, 412, 413, 416, 418, 42, 422, 423, 424, 427, 428, 429, 434, 435, 436, 438, 439, 44, 440, 444, 447, 448, 45, 450, 452, "
      "455, 458, 459, 46, 461, 462, 467, 468, 469, 47, 471, 473, 475, 479, 48, 482, 486, 488, 49, 490, 491, 493, 495, 496, 498, 50, 501, 502, 505, 506, "
      "507, 508, 509, 51, 511, 512, 516, 517, 519, 52, 520, 521, 524, 527, 528, 53, 530, 531, 535, 536, 539, 541, 543, 544, 545, 546, 547, 549, 550, 553, "
      "554, 556, 559, 561, 565, 568, 569, 57, 570, 571, 573, 574, 577, 578, 579, 58, 580, 584, 587, 59, 590, 591, 593, 596, 597, 598, 6, 60, 601, 602, "
      "606, 607, 609, 61, 610, 612, 613, 614, 615, 617, 618, 62, 620, 621, 624, 625, 626, 628, 63, 630, 631, 638, 639, 644, 645, 646, 647, 648, 649, 65, "
      "650, 652, 653, 654, 655, 656, 657, 658, 659, 66, 662, 663, 664, 665, 666, 667, 668, 67, 670, 671, 672, 674, 675, 676, 678, 68, 681, 682, 683, 685, "
      "686, 687, 69, 690, 691, 694, 697, 699, 7, 70, 702, 703, 707, 708, 709, 71, 711, 712, 713, 714, 715, 716, 717, 718, 719, 72, 720, 721, 722, 723, "
      "724, 725, 726, 727, 728, 73, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 753, 754, 756, "
      "757, 758, 759, 76, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 77, 770, 771, 773, 775, 776, 777, 778, 779, 78, 780, 781, 782, 783, 784, 785, "
      "787, 788, 789, 79, 790, 791, 792, 793, 794, 795, 796, 797, 798, 799, 8, 80, 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, "
      "814, 816, 817, 818, 819, 82, 820, 821, 822, 823, 824, 825, 826, 827, 829, 83, 831, 832, 833, 834, 835, 836, 837, 839, 84, 840, 842, 843, 844, 845, "
      "846, 847, 848, 849, 85, 850, 851, 852, 854, 855, 856, 857, 858, 859, 86, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 87, 870, 871, 874, 875, "
      "876, 877, 878, 88, 880, 882, 884, 885, 886, 887, 888, 889, 89, 890, 891, 893, 894, 895, 896, 897, 899, 9, 90, 900, 901, 902, 903, 905, 906, 907, "
      "908, 909, 91, 910, 912, 913, 914, 915, 917, 918, 919, 92, 920, 921, 922, 924, 926, 928, 929, 93, 930, 932, 933, 934, 935, 936, 937, 938, 94, 940, "
      "941, 942, 943, 944, 946, 947, 948, 95, 951, 952, 955, 957, 958, 959, 961, 962, 963, 964, 965, 966, 967, 968, 97, 970, 971, 972, 973, 974, 975, 976, "
      "977, 978, 979, 98, 980, 981, 982, 983, 984, 985, 986, 987, 988, 989, 990, 991, 992, 993, 994, 995, 996, 997, 998, 999, google.";
  const disabledVendorMessage = "Native message: Disabled Vendors: $suffixVendorMessage";
  const enabledVendorMessage = "Native message: Enabled Vendors: $suffixVendorMessage";
  const requiredVendorMessage = "Native message: Required Vendors: $suffixVendorMessage";
  const vendorNames = "Exponential Interactive, Inc d/b/a VDX.tv, Index Exchange, Inc. , Fifty";

  bool isError = false;
  bool isReady = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };

  DidomiSdk.addEventListener(listener);

  group("Vendor", () {
    /*
     * Without initialization
     */

    testWidgets("Get disabled vendor ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledVendorIds", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get enabled vendor ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(enabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getEnabledVendorIds", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get required vendor ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(requiredVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getRequiredVendorIds", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get disabled vendor names without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await tester.tap(disabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledVendors", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get enabled vendor names without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await tester.tap(enabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getEnabledVendors", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get required vendor names without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await tester.tap(requiredVendorsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getRequiredVendors", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get a vendor name without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // Depending on the screen size, we might need to scroll more than once
      // in order to reach the widgets at the bottom of the list.
      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getVendor", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    /*
     * With initialization
     */

    testWidgets("Get disabled vendor ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledVendorIds", emptyDisabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getEnabledVendorIds", emptyEnabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(requiredVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getRequiredVendorIds", requiredVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get disabled vendor names with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(disabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledVendors", emptyDisabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor names with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(enabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getEnabledVendors", emptyEnabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor names with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(requiredVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Vendors: $vendorNames";
      assertNativeMessageStartsWith("getRequiredVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get a vendor name with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Depending on the screen size, we might need to scroll more than once
      // in order to reach the widgets at the bottom of the list.
      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: Google Advertising Products.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + Agree to All
     */

    testWidgets("Get disabled vendor ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledVendorIds", emptyDisabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getEnabledVendorIds", enabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(requiredVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getRequiredVendorIds", requiredVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get disabled vendor names with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(disabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledVendors", emptyDisabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor names with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(enabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Vendors: $vendorNames";
      assertNativeMessageStartsWith("getEnabledVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor names with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(requiredVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Vendors: $vendorNames";
      assertNativeMessageStartsWith("getRequiredVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get a vendor name with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Depending on the screen size, we might need to scroll more than once
      // in order to reach the widgets at the bottom of the list.
      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: Google Advertising Products.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + Disagree to All
     */

    testWidgets("Get disabled vendor ids with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledVendorIds", disabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor ids with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getEnabledVendorIds", emptyEnabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor ids with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(requiredVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getRequiredVendorIds", requiredVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get disabled vendor names with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(disabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Vendors: $vendorNames";
      assertNativeMessageStartsWith("getDisabledVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor names with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(enabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getEnabledVendors", emptyEnabledVendorMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor names with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(requiredVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Vendors: $vendorNames";
      assertNativeMessageStartsWith("getRequiredVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get a vendor name with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Depending on the screen size, we might need to scroll more than once
      // in order to reach the widgets at the bottom of the list.
      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: Google Advertising Products.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
