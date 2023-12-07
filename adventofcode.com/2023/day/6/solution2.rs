use std::convert::TryFrom;
use std::fs::read_to_string;

/* yoink https://doc.rust-lang.org/stable/rust-by-example/std_misc/file/read_lines.html */
fn read_lines(filename: &str) -> Vec<String> {
  read_to_string(filename) 
      .unwrap()  // panic on possible file-reading errors
      .lines()  // split the string into an iterator of string slices
      .map(String::from)  // make each slice into a string
      .collect()  // gather them together into a vector
}

fn extract_numbers(line: String) -> Vec<u64> {
  str::replace(&line, " ", "")
    .split(":")
    .last().unwrap()
    .split(" ")
    .filter(|s| s != &"")
    .map(|s| s.parse::<u64>().unwrap())
    .collect()
}

fn winning_outcomes(T: u64, D: u64) -> Vec<u64> {
  (0..T)
      .map(|t| (T - t) * t)
      .filter(|d| d > &D)
      .collect()

}

fn main() {
  let lines = read_lines("/dev/stdin");
  let mut iter = lines.iter();
  let time = extract_numbers(iter.next().unwrap().to_string());
  let distance = extract_numbers(iter.next().unwrap().to_string());
  let races: Vec<(&u64, u64)> = time.iter().zip(distance).collect();
  let outcomes: Vec<u64> = races.iter()
      .map(|(T, D)| u64::try_from(winning_outcomes(**T, *D).len()).unwrap())
      .collect();

  let result = outcomes.iter()
    .fold(1, |acc, d| acc * d);
  println!("{}", result);
}