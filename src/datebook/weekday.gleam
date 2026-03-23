//// The day of the week.

import gleam/int
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

/// Returns the number of days elapsed between `since` and `day` in a `0..=6` range.
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

/// Returns the weekday corresponding to the number of `days` since `start`.
///
/// If `days` is not between `0` and `6`, it will wrap around modulo 7.
///
/// # Examples
///
/// ```gleam
/// 2 |> from_days_since(Monday)
/// // -> Wednesday
/// ```
///
/// ```gleam
/// -1 |> from_days_since(Sunday)
/// // -> Saturday
/// ```
///
/// ```gleam
/// 0 |> from_days_since(Thursday)
/// // -> Thursday
/// ```
///
/// ```gleam
/// 7 |> from_days_since(Tuesday)
/// // -> Tuesday
/// ```
pub fn from_days_since(days: Int, start: Weekday) -> Weekday {
  let assert Ok(days) = days |> int.modulo(7)

  case start, days {
    Monday, 0
    | Sunday, 1
    | Saturday, 2
    | Friday, 3
    | Thursday, 4
    | Wednesday, 5
    | Tuesday, 6
    -> Monday

    Monday, 1
    | Sunday, 2
    | Saturday, 3
    | Friday, 4
    | Thursday, 5
    | Wednesday, 6
    | Tuesday, 0
    -> Tuesday

    Monday, 2
    | Sunday, 3
    | Saturday, 4
    | Friday, 5
    | Thursday, 6
    | Wednesday, 0
    | Tuesday, 1
    -> Wednesday

    Monday, 3
    | Sunday, 4
    | Saturday, 5
    | Friday, 6
    | Thursday, 0
    | Wednesday, 1
    | Tuesday, 2
    -> Thursday

    Monday, 4
    | Sunday, 5
    | Saturday, 6
    | Friday, 0
    | Thursday, 1
    | Wednesday, 2
    | Tuesday, 3
    -> Friday

    Monday, 5
    | Sunday, 6
    | Saturday, 0
    | Friday, 1
    | Thursday, 2
    | Wednesday, 3
    | Tuesday, 4
    -> Saturday

    Monday, 6
    | Sunday, 0
    | Saturday, 1
    | Friday, 2
    | Thursday, 3
    | Wednesday, 4
    | Tuesday, 5
    -> Sunday

    _, _ -> panic
  }
}
