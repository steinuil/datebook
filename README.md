# datebook

[![Package Version](https://img.shields.io/hexpm/v/datebook)](https://hex.pm/packages/datebook)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/datebook/)

```sh
gleam add gleam_time@1
gleam add datebook@1
```

An extension library for [gleam/time](https://github.com/gleam-lang/time) adding week days and some useful algorithms to work with months and calendar dates.

## Example

```gleam
import datebook/date
import datebook/month
import datebook/weekday
import gleam/time/calendar

pub fn main() {
  // Calculate the weekday based on a calendar.Date
  assert weekday.from_date(calendar.Date(2026, calendar.March, 22))
    == weekday.Sunday

  // Get the next and previous weekday, month, or date
  assert weekday.next(weekday.Thursday) == weekday.Friday
  assert month.next(calendar.January) == calendar.February
  assert date.next(calendar.Date(2026, calendar.March, 22))
    == calendar.Date(2026, calendar.March, 23)

  // Get the last day of a month
  assert month.last_day(calendar.February, 2024) == 29

  // Convert a weekday to a number in Europe
  assert weekday.Thursday |> weekday.days_since(weekday.Monday) == 3
  // ...or in Canada
  assert weekday.Thursday |> weekday.days_since(weekday.Sunday) == 4

  // Get a range of dates
  assert date.range(
      calendar.Date(2026, calendar.March, 29),
      calendar.Date(2026, calendar.April, 2),
    )
    == Ok([
      calendar.Date(2026, calendar.March, 29),
      calendar.Date(2026, calendar.March, 30),
      calendar.Date(2026, calendar.March, 31),
      calendar.Date(2026, calendar.April, 1),
      calendar.Date(2026, calendar.April, 2),
    ])
}
```

Further documentation can be found at <https://hexdocs.pm/datebook>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
