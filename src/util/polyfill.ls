# polyfill.ls

unless String.prototype.padStart?
  String::padStart = (len, pad) ->
    len = len .>>. 0
    pad ?= ' '
    if @length > len
      @ + ''
    else
      len = len - @length
      if len > pad.length
        pad += pad.repeat len / pad.length
      (pad.slice 0, len) + @ + ''
