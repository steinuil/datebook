//// The day of the week.

import gleam/time/calendar.{type Date}
import gleam/time/timestamp

/// The 7 days of the week.
pub type Weekday {
  Monday
  Tuesday
  Wednesday
  Thursday
  Friday
  Saturday
  Sunday
}

/// Returns the English name for a `Weekday`.
///
/// # Examples
///
/// ```gleam
/// to_string(Wednesday)
/// // -> Wednesday
/// ```
pub fn to_string(weekday: Weekday) -> String {
  case weekday {
    Monday -> "Monday"
    Tuesday -> "Tuesday"
    Wednesday -> "Wednesday"
    Thursday -> "Thursday"
    Friday -> "Friday"
    Saturday -> "Saturday"
    Sunday -> "Sunday"
  }
}

/// Returns the `Weekday` for a given `Date`.
///
/// # Examples
///
/// ```gleam
/// from_date(calendar.Date(1970, calendar.January, 1))
/// // -> Thursday
/// ```
pub fn from_date(date: Date) -> Weekday {
  let #(seconds, _) =
    date
    |> timestamp.from_calendar(
      calendar.TimeOfDay(0, 0, 0, 0),
      calendar.utc_offset,
    )
    |> timestamp.to_unix_seconds_and_nanoseconds

  let days_since_epoch = seconds / 86_400

  let weekday = case days_since_epoch >= -4 {
    True -> { days_since_epoch + 4 } % 7
    False -> { days_since_epoch + 5 } % 7 + 6
  }

  case weekday {
    0 -> Sunday
    1 -> Monday
    2 -> Tuesday
    3 -> Wednesday
    4 -> Thursday
    5 -> Friday
    6 -> Saturday
    _ -> panic
  }
}

/// Returns the next `Weekday` for the given `Weekday`.
///
/// # Examples
///
/// ```gleam
/// next(Tuesday)
/// // -> Wednesday
/// ```
pub fn next(weekday: Weekday) -> Weekday {
  case weekday {
    Monday -> Tuesday
    Tuesday -> Wednesday
    Wednesday -> Thursday
    Thursday -> Friday
    Friday -> Saturday
    Saturday -> Sunday
    Sunday -> Monday
  }
}

/// Returns the previous `Weekday` for the given `Weekday`.
///
/// # Examples
///
/// ```gleam
/// previous(Sunday)
/// // -> Saturday
/// ```
pub fn previous(weekday: Weekday) -> Weekday {
  case weekday {
    Monday -> Sunday
    Tuesday -> Monday
    Wednesday -> Tuesday
    Thursday -> Wednesday
    Friday -> Thursday
    Saturday -> Friday
    Sunday -> Saturday
  }
}

/// Returns the number of days elapsed between `right` and `left`.
///
/// You can use this function to map a weekday to a number based on the
/// first day of the week in a given region (e.g. Monday for Europe,
/// Sunday for the US, Saturday for Afghanistan).
///
/// # Examples
///
/// ```gleam
/// Monday |> days_since(Monday)
/// // -> 0
/// ```
/// 
/// ```gleam
/// Sunday |> days_since(Tuesday)
/// // -> 5
/// ```
/// 
/// ```gleam
/// Wednesday |> days_since(Sunday)
/// // -> 3
/// ```
pub fn days_since(day: Weekday, since: Weekday) -> Int {
  case since, day {
    Monday, Monday
    | Tuesday, Tuesday
    | Wednesday, Wednesday
    | Thursday, Thursday
    | Friday, Friday
    | Saturday, Saturday
    | Sunday, Sunday
    -> 0

    Monday, Tuesday
    | Tuesday, Wednesday
    | Wednesday, Thursday
    | Thursday, Friday
    | Friday, Saturday
    | Saturday, Sunday
    | Sunday, Monday
    -> 1

    Monday, Wednesday
    | Tuesday, Thursday
    | Wednesday, Friday
    | Thursday, Saturday
    | Friday, Sunday
    | Saturday, Monday
    | Sunday, Tuesday
    -> 2

    Monday, Thursday
    | Tuesday, Friday
    | Wednesday, Saturday
    | Thursday, Sunday
    | Friday, Monday
    | Saturday, Tuesday
    | Sunday, Wednesday
    -> 3

    Monday, Friday
    | Tuesday, Saturday
    | Wednesday, Sunday
    | Thursday, Monday
    | Friday, Tuesday
    | Saturday, Wednesday
    | Sunday, Thursday
    -> 4

    Monday, Saturday
    | Tuesday, Sunday
    | Wednesday, Monday
    | Thursday, Tuesday
    | Friday, Wednesday
    | Saturday, Thursday
    | Sunday, Friday
    -> 5

    Monday, Sunday
    | Tuesday, Monday
    | Wednesday, Tuesday
    | Thursday, Wednesday
    | Friday, Thursday
    | Saturday, Friday
    | Sunday, Saturday
    -> 6
  }
}
