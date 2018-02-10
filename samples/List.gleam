module List

export length/1, reverse/1, empty?/1, member?/2, head/1, tail/1, filter/2,
       map/2, drop/2, take/2, of/1, new/0

import Maybe exposing Maybe(..)


// Using the Erlang implementations of these functions are they
// are implemented as a BIF in C.
//
foreign length :erlang :length :: List(a) -> Int
foreign reverse :erlang :reverse :: List(a) -> List(a)

let empty?(list) =
  list == []

let member?(list, elem) =
  match list
  | [] => False
  | elem :: _ => True
  | _ :: rest => member?(rest, elem)

let head(list) =
  match list
  | [] => Nothing
  | elem :: _ => Just(elem)

let tail(list) =
  match list
  | [] => Nothing
  | _ :: rest => Just(rest)

let filter(list, fun) =
  filter(list, fun, [])

let filter(list, fun, acc) =
  match list
  | [] => reverse(acc)
  | x :: xs => {
    let new_acc = cond | fun(x) => x :: acc | true => acc
    filter(xs, fun, new_acc)
  }

let map(list, fun) =
  map(list, fun, [])

let map(list, fun, acc) =
  match list
  | [] => reverse(acc)
  | x :: xs => map(xs, fun, fun(x) :: acc)

let drop(list, n) =
  cond
  | n <= 0 => list
  | True => {
    match list
    | [] => []
    | _ :: xs => drop(xs, n - 1)
  }

let take(list, n) =
  take(list, n, [])

let take(list, n, acc) =
  cond
  | n <= 0 => reverse(acc)
  | True => {
    match list
    | [] => reverse(acc)
    | x :: xs => take(xs, n - 1, x :: acc)
  }

let of(x) =
  [x]

let new() =
  []