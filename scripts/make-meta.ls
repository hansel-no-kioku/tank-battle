#------------------------------------------------------------------------------
# Make meta.json

require! {
  fs
  \../package.json : pack
}

pack{name, title, version, author}
  |> JSON.stringify _, null, 2
  |> process.stdout.write
