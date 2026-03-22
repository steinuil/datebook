import datebook/date
import datebook/month
import datebook/weekday
import gleam/time/calendar
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn weekday_from_date_test() {
  assert weekday.from_date(calendar.Date(1970, calendar.January, 1))
    == weekday.Thursday
  assert weekday.from_date(calendar.Date(1776, calendar.July, 4))
    == weekday.Thursday
  assert weekday.from_date(calendar.Date(2026, calendar.February, 28))
    == weekday.Saturday
}

pub fn weekday_days_since_test() {
  assert weekday.Monday |> weekday.days_since(weekday.Monday) == 0
  assert weekday.Monday |> weekday.days_since(weekday.Tuesday) == 6
  assert weekday.Sunday |> weekday.days_since(weekday.Tuesday) == 5
  assert weekday.Wednesday |> weekday.days_since(weekday.Sunday) == 3
}

pub fn month_last_day_test() {
  assert month.last_day(calendar.February, 2024) == 29
  assert month.last_day(calendar.February, 2025) == 28
}

pub fn date_next_test() {
  assert date.next(calendar.Date(2025, calendar.December, 31))
    == calendar.Date(2026, calendar.January, 1)
  assert date.next(calendar.Date(2024, calendar.February, 28))
    == calendar.Date(2024, calendar.February, 29)
  assert date.next(calendar.Date(2024, calendar.February, 29))
    == calendar.Date(2024, calendar.March, 1)
}

pub fn date_previous_test() {
  assert date.previous(calendar.Date(2025, calendar.January, 1))
    == calendar.Date(2024, calendar.December, 31)
  assert date.previous(calendar.Date(2024, calendar.March, 1))
    == calendar.Date(2024, calendar.February, 29)
}

pub fn date_range_test() {
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

  assert date.range(
      calendar.Date(2026, calendar.March, 29),
      calendar.Date(2026, calendar.March, 29),
    )
    == Ok([
      calendar.Date(2026, calendar.March, 29),
    ])

  assert date.range(
      calendar.Date(2026, calendar.March, 22),
      calendar.Date(2026, calendar.March, 21),
    )
    == Error(Nil)
}

pub fn readme_test() {
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
