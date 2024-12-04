let filename = "in.q2.txt"

type state =
  | Scanning_do_d
  | Ensure_do_o
  | Ensure_do_lparen
  | Ensure_do_rparen
  | Scanning_mul_m
  | Ensure_mul_u
  | Ensure_mul_l
  | Ensure_mul_lparen
  | Read_n1
  | Read_n2
  | Ensure_dont_o
  | Ensure_dont_n
  | Ensure_dont_apostrophe
  | Ensure_dont_t
  | Ensure_dont_lparen
  | Ensure_dont_rparen

let rec p acc state ic acc_n1 acc_n2 =
  try
    let c = input_char ic in
    match state with
    | Scanning_do_d ->
        if c = 'd' then p acc Ensure_do_o ic 0 0 else p acc Scanning_do_d ic 0 0
    | Ensure_do_o ->
        if c = 'o' then p acc Ensure_do_lparen ic 0 0
        else p acc Scanning_do_d ic 0 0
    | Ensure_do_lparen ->
        if c = '(' then p acc Ensure_do_rparen ic 0 0
        else p acc Scanning_do_d ic 0 0
    | Ensure_do_rparen ->
        if c = ')' then p acc Scanning_mul_m ic 0 0
        else p acc Scanning_do_d ic 0 0
    | Scanning_mul_m -> (
        match c with
        | 'm' -> p acc Ensure_mul_u ic 0 0
        | 'd' -> p acc Ensure_dont_o ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Ensure_mul_u -> (
        match c with
        | 'u' -> p acc Ensure_mul_l ic 0 0
        | 'd' -> p acc Ensure_dont_o ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Ensure_mul_l -> (
        match c with
        | 'l' -> p acc Ensure_mul_lparen ic 0 0
        | 'd' -> p acc Ensure_dont_o ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Ensure_mul_lparen -> (
        match c with
        | '(' -> p acc Read_n1 ic 0 0
        | 'd' -> p acc Ensure_dont_o ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Read_n1 -> (
        match c with
        | '0' .. '9' -> p acc Read_n1 ic ((acc_n1 * 10) + (int_of_char c - int_of_char '0')) 0
        | 'd' -> p acc Ensure_dont_o ic 0 0
        | ',' -> p acc Read_n2 ic acc_n1 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Read_n2 -> (
        match c with
        | '0' .. '9' -> p acc Read_n2 ic acc_n1 ((acc_n2 * 10) + (int_of_char c - int_of_char '0'))
        | 'd' -> p acc Ensure_dont_o ic 0 0
        | ')' -> p (acc + (acc_n1 * acc_n2)) Scanning_mul_m ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Ensure_dont_o -> (
        match c with
        | 'o' -> p acc Ensure_dont_n ic 0 0
        | 'm' -> p acc Ensure_mul_u ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Ensure_dont_n -> (
        match c with
        | 'n' -> p acc Ensure_dont_apostrophe ic 0 0
        | 'm' -> p acc Ensure_mul_u ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Ensure_dont_apostrophe -> (
        match c with
        | '\'' -> p acc Ensure_dont_t ic 0 0
        | 'm' -> p acc Ensure_mul_u ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Ensure_dont_t -> (
        match c with
        | 't' -> p acc Ensure_dont_lparen ic 0 0
        | 'm' -> p acc Ensure_mul_u ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Ensure_dont_lparen -> (
        match c with
        | '(' -> p acc Ensure_dont_rparen ic 0 0
        | 'm' -> p acc Ensure_mul_u ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
    | Ensure_dont_rparen -> (
        match c with
        | ')' -> p acc Scanning_do_d ic 0 0
        | 'd' -> p acc Scanning_mul_m ic 0 0
        | _ -> p acc Scanning_mul_m ic 0 0)
  with End_of_file -> acc

let () =
  let ic = open_in filename in
  let result = p 0 Scanning_mul_m ic 0 0 in
  Printf.printf "Result: %d\n" result;
  close_in ic
