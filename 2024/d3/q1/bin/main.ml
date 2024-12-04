let filename = "in.q1.txt"

type state =
  | Scanning_m
  | Ensure_u
  | Ensure_l
  | Ensure_lparen
  | Read_n1
  | Read_n2

let rec p acc state ic acc_n1 acc_n2 =
  try
    let c = input_char ic in
    match state with
    | Scanning_m ->
        if c = 'm' then p acc Ensure_u ic 0 0 else p acc Scanning_m ic 0 0
    | Ensure_u ->
        if c = 'u' then p acc Ensure_l ic 0 0 else p acc Scanning_m ic 0 0
    | Ensure_l ->
        if c = 'l' then p acc Ensure_lparen ic 0 0 else p acc Scanning_m ic 0 0
    | Ensure_lparen ->
        if c = '(' then p acc Read_n1 ic 0 0 else p acc Scanning_m ic 0 0
    | Read_n1 -> (
        match c with
        | '0' .. '9' ->
            p acc Read_n1 ic
              ((acc_n1 * 10) + (int_of_char c - int_of_char '0'))
              0
        | ',' -> p acc Read_n2 ic acc_n1 0
        | _ -> p acc Scanning_m ic 0 0)
    | Read_n2 -> (
        match c with
        | '0' .. '9' ->
            p acc Read_n2 ic acc_n1
              ((acc_n2 * 10) + (int_of_char c - int_of_char '0'))
        | ')' -> p (acc + (acc_n1 * acc_n2)) Scanning_m ic 0 0
        | _ -> p acc Scanning_m ic 0 0)
  with End_of_file -> acc

let () =
  let ic = open_in filename in
  let count = p 0 Scanning_m ic 0 0 in
  print_endline (string_of_int count);
  close_in ic
