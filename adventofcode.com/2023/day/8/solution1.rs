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

#[derive(Debug, Clone)]
struct Node<'a> {
  name: &'a str,
  left: &'a str,
  right: &'a str,
}

#[derive(Debug)]
struct Graph<'a> {
  nodes: Vec<Node<'a>>
}

impl <'a> TryFrom<Vec<&'a str>> for Graph<'a> {
  type Error = &'static str;
  fn try_from(lines: Vec<&'a str>) -> Result<Self, Self::Error> {
    let mut nodes: Vec<Node> = Default::default();
    for line in lines {
      let name = line.get(0..3).ok_or("Invalid string format")?;
      let left = line.get(7..10).ok_or("Invalid string format")?;
      let right = line.get(12..15).ok_or("Invalid string format")?;

      nodes.push(Node { name, left, right })
    }

    Ok(Graph { nodes })
  }
}

impl Graph<'_> {
  fn navigate(&self, from: Node, left: bool) -> Option<Node<'_>> {
    println!("Navigating {} from {}", match left {
      true => "L",
      false => "R"
    }, from.name);
    
    match left {
      true => self.find(from.left),
      false => self.find(from.right),
    }
  }

  fn find(&self, name: &str) -> Option<Node<'_>> {
    println!("Searching for {}", name);
    self.nodes.iter()
      .find(|node| node.name == name)
      .and_then(|node| Some(node.clone()))
  }
}

fn main() {
  let lines = read_lines("/dev/stdin");
  let mut lines = lines.iter();
  let directions = lines.next().expect("missing directions").bytes();
  lines.next().expect("missing seperator");

  let lines: Vec<&str> = lines.map(|s| s.as_str()).collect();
  let graph = Graph::try_from(lines).expect("invalid input");

  let mut node = graph.find("AAA").expect("missing start node");
  let mut i = 0;
  while node.name != "ZZZ" {
    let left = match directions.clone().nth(i % directions.len()).unwrap() {
      b'L' => true,
      b'R' => false,
      _ => panic!("invalid directions"),
    };

    node = graph.navigate(node, left).expect("invalid node edge -- cannot navigate");

    i += 1;
  }

  println!("Took {} steps", i);
}