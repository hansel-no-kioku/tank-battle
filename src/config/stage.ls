# stage.ls

require! {
  './enemy': {enemies : e}
}

export stages = [
  #
  {enemy: [e.light-w]}
  {enemy: [e.light-w, e.light-w, e.light-w]}
  {enemy: [e.missiler-w, e.missiler-w, e.missiler-w]}
  {enemy: [e.middle-w, e.middle-w, e.middle-w]}
  {enemy: [e.heavy-w, e.heavy-w, e.heavy-w]}
  {enemy: [e.light-w, e.light-w, e.light-w, e.light-w, e.light-w]}
  {enemy: [e.missiler-w, e.missiler-w, e.missiler-w
    e.missiler-w, e.missiler-w]}
  {enemy: [e.middle-w, e.missiler-w, e.missiler-w, e.light-w, e.light-w]}
  {enemy: [e.fortress-w, e.heavy-w, e.heavy-w, e.missiler-w, e.missiler-w]}
  #
  {enemy: [e.light-s]}
  {enemy: [e.light-s, e.light-s, e.light-s]}
  {enemy: [e.missiler-s, e.missiler-s, e.missiler-s]}
  {enemy: [e.middle-s, e.middle-s, e.middle-s]}
  {enemy: [e.heavy-s, e.heavy-s, e.heavy-s]}
  {enemy: [e.light-s, e.light-s, e.light-s, e.light-s, e.light-s]}
  {enemy: [e.missiler-s, e.missiler-s, e.missiler-s
    e.missiler-s, e.missiler-s]}
  {enemy: [e.middle-s, e.missiler-s, e.missiler-s, e.light-s, e.light-s]}
  {enemy: [e.fortress-s, e.heavy-s, e.heavy-s, e.missiler-s, e.missiler-s]}
]
