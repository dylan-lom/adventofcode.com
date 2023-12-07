use std::fs::read_to_string;
use std::ops::Range;
use std::convert::TryInto;

/* yoink https://doc.rust-lang.org/stable/rust-by-example/std_misc/file/read_lines.html */
fn read_lines(filename: &str) -> Vec<String> {
  read_to_string(filename) 
      .unwrap()  // panic on possible file-reading errors
      .lines()  // split the string into an iterator of string slices
      .map(String::from)  // make each slice into a string
      .collect()  // gather them together into a vector
}

fn extract_seeds(input: &Vec<String>) -> Vec<i64> {
  let seeds: &str = input
      .first()
      .expect("The first line of input should be seeds")
      .split(": ")
      .last()
      .expect("The format of the first line should be seeds: ...");

  seeds.split(" ")
    .map(|s| s.trim().parse::<i64>().unwrap())
    .collect()
}

#[derive(Debug, Clone)]
struct MappingRange {
  dest: Range<i64>,
  src: Range<i64>,
}

#[derive(Debug, Clone)]
struct Mapping {
  ranges: Vec<MappingRange>,
}

impl Mapping {
  fn location_of(&mut self, x: i64) -> i64 {
    match self.ranges.iter_mut().find(|r| r.src.contains(&x)) {
      Some(r) => r.dest
          .nth((x - r.src.start).try_into().unwrap())
          .unwrap(),
      None => x,
    }
  }
}

fn extract_map(input: Vec<String>) -> Mapping {
  let (last_line, _) = input.iter()
    .enumerate()
    .find(|(_, line)| line.to_string() == "")
    .or(Some((input.len() - 1, &"".to_string())))
    .unwrap();

  Mapping {
    ranges: input[1..last_line]
      .iter()
      .map(|line| line
        .split(" ")
        .map(|s| s.parse::<i64>().unwrap())
        .collect()
      )
      .map(|v: Vec<i64>| MappingRange {
        dest: v[0]..v[0] + v[2],
        src: v[1]..v[1] + v[2],
      })
      .collect()
  }
}

fn extract_maps(lines: Vec<String>) -> Vec<Mapping> {
  lines.iter()
      .enumerate()
      .filter(|(_, line)| line.ends_with("map:"))
      .map(|(i, _)| extract_map(lines[i..].to_vec()))
      .collect()
}

fn find_location(seed: &i64, mut maps: Vec<Mapping>) -> i64 {
  maps.iter_mut()
    .fold(*seed, |acc, map| map.location_of(acc))
}

fn main() {
  let input = read_lines("/dev/stdin");
  
  let seeds = extract_seeds(&input);
  let maps = extract_maps(input);
  let mut locations: Vec<i64> = seeds.iter()
    .map(|seed| find_location(&seed, maps[..].to_vec()))
    .collect();
  
  locations.sort();
  let min = locations.first().unwrap();

  println!("{}", min)
}