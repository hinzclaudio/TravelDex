// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localizable {
  /// Add Image
  internal static let actionAddImage = Localizable.tr("Localizable", "action_add_image", fallback: "Add Image")
  /// Add Location
  internal static let actionAddLocation = Localizable.tr("Localizable", "action_add_location", fallback: "Add Location")
  /// Change Image
  internal static let actionChangeImage = Localizable.tr("Localizable", "action_change_image", fallback: "Change Image")
  /// Delete
  internal static let actionDelete = Localizable.tr("Localizable", "action_delete", fallback: "Delete")
  /// Delete Image
  internal static let actionDeleteImage = Localizable.tr("Localizable", "action_delete_image", fallback: "Delete Image")
  /// Edit
  internal static let actionEdit = Localizable.tr("Localizable", "action_edit", fallback: "Edit")
  /// Edit Comment
  internal static let actionEditComment = Localizable.tr("Localizable", "action_edit_comment", fallback: "Edit Comment")
  /// Pick Color
  internal static let actionPickColor = Localizable.tr("Localizable", "action_pick_color", fallback: "Pick Color")
  /// Show on Map
  internal static let actionShowOnMap = Localizable.tr("Localizable", "action_show_on_map", fallback: "Show on Map")
  /// Add Location
  internal static let addLocationTitle = Localizable.tr("Localizable", "add_location_title", fallback: "Add Location")
  /// Localizable.strings
  ///   TravelDex
  /// 
  ///   Created by Claudio Hinz on 03.09.22.
  internal static let addPlacesTitle = Localizable.tr("Localizable", "add_places_title", fallback: "Add Places")
  /// Add Trip
  internal static let addTripTitle = Localizable.tr("Localizable", "add_trip_title", fallback: "Add Trip")
  /// Color Selection
  internal static let colorSelectionTitle = Localizable.tr("Localizable", "color_selection_title", fallback: "Color Selection")
  /// What made this place so special?
  internal static let commentLocationSubtitle = Localizable.tr("Localizable", "comment_location_subtitle", fallback: "What made this place so special?")
  /// Enter a Comment for %@
  internal static func commentLocationTitle(_ p1: Any) -> String {
    return Localizable.tr("Localizable", "comment_location_title", String(describing: p1), fallback: "Enter a Comment for %@")
  }
  /// End
  internal static let end = Localizable.tr("Localizable", "end", fallback: "End")
  /// Your query did not produce any results.
  internal static let errorCannotMatchLocation = Localizable.tr("Localizable", "error_cannot_match_location", fallback: "Your query did not produce any results.")
  /// Error
  internal static let errorTitle = Localizable.tr("Localizable", "error_title", fallback: "Error")
  /// (optional)
  internal static let locationCountryTfSubtitle = Localizable.tr("Localizable", "location_country_tf_subtitle", fallback: "(optional)")
  /// Country
  internal static let locationCountryTfTitle = Localizable.tr("Localizable", "location_country_tf_title", fallback: "Country")
  /// Title
  internal static let locationNameTfTitle = Localizable.tr("Localizable", "location_name_tf_title", fallback: "Title")
  /// (optional)
  internal static let locationRegionTfSubtitle = Localizable.tr("Localizable", "location_region_tf_subtitle", fallback: "(optional)")
  /// Region
  internal static let locationRegionTfTitle = Localizable.tr("Localizable", "location_region_tf_title", fallback: "Region")
  /// Image
  internal static let menuImageTitle = Localizable.tr("Localizable", "menu_image_title", fallback: "Image")
  /// Menu
  internal static let menuTitle = Localizable.tr("Localizable", "menu_title", fallback: "Menu")
  /// You did not add any locations yet. Add a location by tapping the plus icon!
  internal static let missingLocations = Localizable.tr("Localizable", "missing_locations", fallback: "You did not add any locations yet. Add a location by tapping the plus icon!")
  /// You did not add any trips yet. Add a trip by tapping the plus icon!
  internal static let missingTrips = Localizable.tr("Localizable", "missing_trips", fallback: "You did not add any trips yet. Add a trip by tapping the plus icon!")
  /// OK
  internal static let ok = Localizable.tr("Localizable", "ok", fallback: "OK")
  /// Search Locations
  internal static let searchLocationTitle = Localizable.tr("Localizable", "search_location_title", fallback: "Search Locations")
  /// Start
  internal static let start = Localizable.tr("Localizable", "start", fallback: "Start")
  /// What was your trip about? (optional)
  internal static let tripDescrTfSubtitle = Localizable.tr("Localizable", "trip_descr_tf_subtitle", fallback: "What was your trip about? (optional)")
  /// Description
  internal static let tripDescrTfTitle = Localizable.tr("Localizable", "trip_descr_tf_title", fallback: "Description")
  /// Who was travelling with you? (optional)
  internal static let tripMembersTfSubtitle = Localizable.tr("Localizable", "trip_members_tf_subtitle", fallback: "Who was travelling with you? (optional)")
  /// Fellow Travelers
  internal static let tripMembersTfTitle = Localizable.tr("Localizable", "trip_members_tf_title", fallback: "Fellow Travelers")
  /// Title
  internal static let tripNameTfTitle = Localizable.tr("Localizable", "trip_name_tf_title", fallback: "Title")
  /// Trips
  internal static let tripsListTitle = Localizable.tr("Localizable", "trips_list_title", fallback: "Trips")
  /// An unknown error occured.
  internal static let unknownErrorDescr = Localizable.tr("Localizable", "unknown_error_descr", fallback: "An unknown error occured.")
  /// Visited Places
  internal static let visistedPlaceTitle = Localizable.tr("Localizable", "visisted_place_title", fallback: "Visited Places")
  /// Visited Locations
  internal static let visitedLocationsTitle = Localizable.tr("Localizable", "visited_locations_title", fallback: "Visited Locations")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localizable {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
