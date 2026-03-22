//// Utility functions for `gleam/time`'s `calendar.Month`.

import gleam/time/calendar.{type Month}

/// Returns the last day of the month in a given year.
///
/// # Examples
///
/// ```gleam
/// last_day(March, 2005)
/// // -> 31
/// ```
///
/// ```gleam
/// last_day(February, 2024)
/// // -> 29
/// ```
/// 
/// ```gleam
/// last_day(February, 2025)
/// // -> 28
/// ```
pub fn last_day(month: Month, year: Int) -> Int {
  case month {
    calendar.February ->
      case calendar.is_leap_year(year) {
        True -> 29
        False -> 28
      }
    calendar.April | calendar.June | calendar.September | calendar.November ->
      30
    calendar.January
    | calendar.March
    | calendar.May
    | calendar.July
    | calendar.August
    | calendar.October
    | calendar.December -> 31
  }
}

/// Returns the next month for a given `Month`.
///
/// # Examples
///
/// ```gleam
/// next(March)
/// // -> April
/// ```
pub fn next(month: Month) -> Month {
  case month {
    calendar.January -> calendar.February
    calendar.February -> calendar.March
    calendar.March -> calendar.April
    calendar.April -> calendar.May
    calendar.May -> calendar.June
    calendar.June -> calendar.July
    calendar.July -> calendar.August
    calendar.August -> calendar.September
    calendar.September -> calendar.October
    calendar.October -> calendar.November
    calendar.November -> calendar.December
    calendar.December -> calendar.January
  }
}

/// Returns the previous month for a given `Month`.
///
/// # Examples
///
/// ```gleam
/// previous(March)
/// // -> February
/// ```
pub fn previous(month: Month) -> Month {
  case month {
    calendar.January -> calendar.December
    calendar.February -> calendar.January
    calendar.March -> calendar.February
    calendar.April -> calendar.March
    calendar.May -> calendar.April
    calendar.June -> calendar.May
    calendar.July -> calendar.June
    calendar.August -> calendar.July
    calendar.September -> calendar.August
    calendar.October -> calendar.September
    calendar.November -> calendar.October
    calendar.December -> calendar.November
  }
}
