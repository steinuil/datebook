//// Utility functions for `gleam/time`'s `calendar.Date`.

import datebook/month
import gleam/bool
import gleam/order
import gleam/time/calendar.{type Date}

/// Returns the next date for a given `Date`.
///
/// Will return a nonsensical result if the provided `Date` is not valid.
/// Validate it with `calendar.is_valid_date` first!
///
/// # Examples
///
/// ```gleam
/// next(calendar.Date(2026, calendar.March, 22))
/// // -> calendar.Date(2026, calendar.March, 23)
/// ```
pub fn next(date: Date) -> Date {
  let #(month, day) = case date.day == month.last_day(date.month, date.year) {
    True -> #(month.next(date.month), 1)
    False -> #(date.month, date.day + 1)
  }

  let year = case month, day {
    calendar.January, 1 -> date.year + 1
    _, _ -> date.year
  }

  calendar.Date(year, month, day)
}

/// Returns the previous date for a given `Date`.
///
/// Will return a nonsensical result if the provided `Date` is not valid.
/// Validate it with `calendar.is_valid_date` first!
///
/// # Examples
///
/// ```gleam
/// previous(calendar.Date(2026, calendar.March, 22))
/// // -> calendar.Date(2026, calendar.March, 21)
/// ```
pub fn previous(date: Date) -> Date {
  let #(month, day) = case date.day == 1 {
    True -> {
      let month = month.previous(date.month)
      #(month, month.last_day(month, date.year))
    }
    False -> #(date.month, date.day - 1)
  }

  let year = case month, day {
    calendar.December, 31 -> date.year - 1
    _, _ -> date.year
  }

  calendar.Date(year, month, day)
}

fn range_rec(from: Date, to: Date, acc: List(Date)) -> List(Date) {
  case from == to {
    True -> [from, ..acc]
    False -> range_rec(from, previous(to), [to, ..acc])
  }
}

/// Returns the inclusive list of dates between `from` and `to`.
/// 
/// Fails if `from` > `to` and when `from` or `to` are invalid dates.
///
/// # Examples
///
/// ```gleam
/// range(Date(2026, March, 29), Date(2026, April, 2))
/// // -> Ok([
/// //   Date(2026, March, 29),
/// //   Date(2026, March, 30),
/// //   Date(2026, March, 31),
/// //   Date(2026, April, 1),
/// //   Date(2026, April, 2),
/// // ])
/// ```
///
/// ```gleam
/// range(Date(2026, March, 22), Date(2026, March, 22))
/// // -> Ok([Date(2026, March, 22)])
/// ```
///
/// ```gleam
/// range(Date(2026, March, 22), Date(2026, March, 21))
/// // -> Error(Nil)
/// ```
pub fn range(from: Date, to: Date) -> Result(List(Date), Nil) {
  use <- bool.guard(
    !calendar.is_valid_date(from)
      || !calendar.is_valid_date(to)
      || calendar.naive_date_compare(from, to) == order.Gt,
    Error(Nil),
  )

  Ok(range_rec(from, to, []))
}
